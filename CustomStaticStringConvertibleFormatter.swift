/// Add support for formatting `CustomStaticStringConvertible` types.
extension Formatter where Value: CustomStaticStringConvertible {
  /// Creates a new formatter for `CustomStaticStringConvertible` types.
  @inlinable @inline(__always)
  public static var staticDescription: Formatter<Value> {
    Formatter<Value> { value, printer in
      printer.print(value.staticDescription)
    }
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to `CustomStaticStringConvertible` types.
extension CustomStaticStringConvertible {
  /// The default formatter for `CustomStaticStringConvertible` types.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.staticDescription
  }
}
