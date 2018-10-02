# Google Sheets Ruby output plugin for Embulk

Dumps records to Google Sheets.

## Overview

* **Plugin type**: output
* **Load all or nothing**: yes
* **Resume supported**: no
* **Cleanup supported**: no

## Configuration

- **spreadsheet_id**: Spreadsheet ID (string, required)
- **credentials_path**: Credentials JSON path (string, default: `"credentials.json"`)

## Example

```yaml
out:
  type: google_sheets_ruby
  spreadsheet_id: YOUR_SPREAD_SHEET_ID
  credentials_path: /path/to/credentials.json
  range: A1
```


## Build

```
$ rake
```
