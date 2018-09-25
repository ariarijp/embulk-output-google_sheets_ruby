require 'fileutils'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

APPLICATION_NAME = 'embulk-output-google_sheets_ruby'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

module Embulk
  module Output
    class GoogleSheets < OutputPlugin
      Plugin.register_output('google_sheets_ruby', self)

      def self.transaction(config, schema, count, &control)
        task = {
          'spreadsheet_id' => config.param('spreadsheet_id', :string),
          'credentials_path' => config.param('credentials_path', :string, default: 'credentials.json'),
        }

        task_reports = yield(task)

        {}
      end

      def init
        @spreadsheet_id = task['spreadsheet_id']
        @credentials_path = task['credentials_path']
        @rows = []
        @rows << schema.map do |column|
          column.name
        end

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
        value_range.range = 'A1'
        value_range.major_dimension = 'ROWS'
        value_range.values = @rows

        @service.update_spreadsheet_value(
          @spreadsheet_id, 
          value_range.range,
          value_range,
          value_input_option: 'USER_ENTERED',
        )

        {}
      end

      def authorize
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(@credentials_path),
          scope: SCOPE
        )
        authorizer.fetch_access_token!

        authorizer
      end
    end
  end
end
