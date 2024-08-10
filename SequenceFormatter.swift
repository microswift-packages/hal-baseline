/// Adds support for formatting sequences of values.
extension Formatter where Value: Sequence {
  /// Creates a new formatter for sequences of values.
  ///
  /// - Parameter separator: The separator to use between values. (default: ", ")
  /// - Parameter prefix: The prefix to use before the first value. (default: "")
  /// - Parameter suffix: The suffix to use after the last value. (default: "")
  @inlinable @inline(__always)
  public static func sequence(
    separator: StaticString = ", ",
    prefix: StaticString = "",
    suffix: StaticString = "",
    formatter: Formatter<Value.Element>
  ) -> Formatter<Value> {
    Formatter<Value> { value, printer in
      printer.print(prefix)
      var first = true
      for element in value {
        if first {
          first = false
        } else {
          printer.print(separator)
        }
        printer.print(element, as: formatter)
      }
      printer.print(suffix)
    }
  }
}

extension Formatter where Value: Sequence, Value.Element: DefaultFormatterProvider {
  /// Creates a new formatter for sequences of values.
  ///
  /// - Parameter separator: The separator to use between values. (default: ", ")
  /// - Parameter prefix: The prefix to use before the first value. (default: "")
  /// - Parameter suffix: The suffix to use after the last value. (default: "")
  @inlinable @inline(__always)
  public static func sequence(
    separator: StaticString = ", ",
    prefix: StaticString = "", suffix: StaticString = ""
  ) -> Formatter<Value> {
    sequence(
      separator: separator, prefix: prefix, suffix: suffix,
      formatter: Value.Element.defaultFormatter)
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to sequences of values.
extension Sequence where Element: DefaultFormatterProvider {
  /// The default formatter for sequences of values.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.sequence(formatter: Element.defaultFormatter)
  }
}
