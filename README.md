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

## Headers

By default the first line of the encoded text is a header, using the names of the properties. 

This can be disabled with `encoder.headerEncodingStrategy = .none`, or you can supply header names to the encoder manually when you create it. 

You can also supply some translation settings with an optional bundle, table and/or prefix. If these are supplied, the header names are used as NSLocalizedString keys, and the resulting translated versions are written out.  

## Decoding

Currently only encoding is supported. Simple decoding should be quite easy for me to add however, so please open an issue if you need it.
