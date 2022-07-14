# CSVEncoder

Very basic support for encoding an Swift object as CSV.

## Usage

```swift
let encoder = CSVEncoder()
encoder.dateEncodingStragegy = .iso8601
let data = try! encoder.encode(rows: [MyCodableThing()])
```

You pass the encoder a list of codable objects.

This results in a data object which is a UTF-8 string.

Each line of the string contains a value for each property of the codable object.

By default the first line is a header, using the names of the properties. This can be disabled with `encoder.headerEncodingStrategy = .none`.
.

## Decoding

Currently only encoding is supported. Simple decoding should be quite easy to add however, so please add an issue if you need it.
