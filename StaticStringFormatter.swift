/// Adds support for formatting `StaticString`s.
extension Formatter where Value == StaticString {
  /// Creates a new formatter for `StaticString`s.
  @inlinable @inline(__always)
  public static var staticString: Formatter<Value> {
    Formatter<Value> { value, printer in
      for char in value {
        printer.writeByte(char)
      }
    }
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to `StaticString`.
extension StaticString: DefaultFormatterProvider {
  /// The default formatter for `StaticString`.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.staticString
  }
}
