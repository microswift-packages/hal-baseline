/// A ``Formatter`` is a type that can format values into a ``Printer``.
public struct Formatter<Value> {
  /// The function to use for formatting.
  @usableFromInline
  let format: (Value, Printer) -> Void

  /// Creates a new formatter.
  ///
  /// - Parameter format: The function to use for formatting.
  @inlinable @inline(__always)
  public init(_ format: @escaping (Value, Printer) -> Void) {
    self.format = format
  }

  /// Formats a value into a ``Printer``.
  ///
  /// - Parameter value: The value to format.
  /// - Parameter printer: The printer to format the value into.
  @inlinable @inline(__always)
  public func format(_ value: Value, into printer: Printer) {
    format(value, printer)
  }
}
