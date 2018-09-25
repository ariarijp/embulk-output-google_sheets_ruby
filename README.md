# Google Sheets Ruby output plugin for Embulk

TODO: Write short description here and embulk-output-google_sheets_ruby.gemspec file.

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
```


## Build

```
$ rake
```
