/// Adds ``Formatter`` support for `Bool`.
extension Formatter where Value == Bool {
  /// Creates a new formatter for `Bool`s.
  @inlinable @inline(__always)
  public static var trueOrFalse: Formatter<Value> {
    Formatter<Value> { value, printer in
      printer.print(value ? "true" : "false")
    }
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to `Bool`.
extension Bool: DefaultFormatterProvider {
  /// The default formatter for `Bool`.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.trueOrFalse
  }
}