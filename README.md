# Google Sheets Ruby output plugin for Embulk

Dumps records to Google Sheets.

## Overview

- **Plugin type**: output
- **Load all or nothing**: yes
- **Resume supported**: no
- **Cleanup supported**: no

## Configuration

| name             | type   | requirement | default              | description                            |
| :--------------- | :----- | :---------- | :------------------- | :------------------------------------- |
| spreadsheet_id   | string | required    |                      |                                        |
| credentials_path | string | optional    | `"credentials.json"` | keyfile path                           |
| range            | string | optional    | `"A1"`               |                                        |
| auth_method      | string | optional    | `service_account`    | `service_account` or `authorized_user` |

##### about credentials_path

- if `auth_method` is `service_account`, set the service account credential json file path.
- if `auth_method` is `authorized_user`, this plugin supposes the format is the below.

```json
{
  "client_id": "xxxxxxxxxxx.apps.googleusercontent.com",
  "client_secret": "xxxxxxxxxxx",
  "refresh_token": "xxxxxxxxxxx"
}
```

## Example

```yaml
out:
  type: google_sheets_ruby
  spreadsheet_id: YOUR_SPREAD_SHEET_ID
  credentials_path: /path/to/credentials.json
  range: A1
```

## Prepare JSON file for auth_method: authorized_user

You may use [example/setup_authorized_user_credentials.rb](example/setup_authorized_user_credentials.rb) to prepare OAuth token.

Go to GCP console > API Manager > Credentials > Create 'OAuth Client ID'. Get the client id and client secret.

Run `setup_authorized_user_credentials.rb` to get `refresh_token`.

```
bundle --path vendor/bundle
bundle exec ruby example/setup_authorized_user_credentials.rb
```

## Build

```
$ rake
```
