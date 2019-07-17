require 'fileutils'
require 'google/apis/sheets_v4'
require 'googleauth'

APPLICATION_NAME = 'embulk-output-google_sheets_ruby'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

module Embulk
  module Output
    # Google Sheets Ruby output plugin for Embulk
    class GoogleSheetsRuby < OutputPlugin
      Plugin.register_output('google_sheets_ruby', self)

      def self.transaction(config, _schema, _count)
        task = {
          'spreadsheet_id' => config.param('spreadsheet_id', :string),
          'range' => config.param('range', :string, default: 'A1'),
          'credentials_path' => config.param('credentials_path',
                                             :string,
                                             default: 'credentials.json'),
          'auth_method' => config.param('auth_method', :string, default: 'service_account')
        }

        yield(task)

        {}
      end

      def init
        @spreadsheet_id = task['spreadsheet_id']
        @credentials_path = task['credentials_path']
        @range = task['range']
        @auth_method = task['auth_method']
        @rows = []
        @rows << schema.map(&:name)

        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.client_options.application_name = APPLICATION_NAME
        @service.authorization = authorize
      end

      def add(page)
        page.each do |record|
          @rows << record
        end
      end

      def commit
        value_range = Google::Apis::SheetsV4::ValueRange.new
        value_range.range = @range
        value_range.major_dimension = 'ROWS'
        value_range.values = @rows

        update_sheet(value_range)

        {}
      end

      def authorize
        case @auth_method
        when 'service_account'
          return Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: File.open(@credentials_path),
            scope: SCOPE
            )
        when 'authorized_user'
          return Google::Auth::UserRefreshCredentials.make_creds(
            json_key_io: File.open(@credentials_path),
            scope: SCOPE
            )
        else
          raise ConfigError.new("Unknown auth method: #{auth_method}")
        end
      end

      def update_sheet(value_range)
        @service.update_spreadsheet_value(
          @spreadsheet_id,
          value_range.range,
          value_range,
          value_input_option: 'USER_ENTERED'
        )
      end
    end
  end
end
