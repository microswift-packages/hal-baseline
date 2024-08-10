/// A support type for printing.
public struct Printer {
  /// The base function to use for writing a byte.
  ///
  /// - Parameter byte: The byte to write.
  public let writeByte: (UInt8) -> Void

  /// Creates a new printer.
  ///
  /// - Parameter writeByte: The base function to use for writing a byte.
  @inlinable @inline(__always)
  public init(_ writeByte: @escaping (UInt8) -> Void) {
    self.writeByte = writeByte
  }

  /// Writes a sequence of bytes.
  ///
  /// - Parameter bytes: The bytes to write.
  @inlinable @inline(__always)
  public func writeBytes<S: Sequence>(_ bytes: S) where S.Element == UInt8 {
    for byte in bytes {
      writeByte(byte)
    }
  }

  /// Prints a `newline` character.
  @inlinable @inline(__always)
  public func println() {
    writeByte(0x0A)
  }

  /// Prints a `Value` with a ``Formatter``.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  @inlinable @inline(__always)
  public func print<Value>(_ value: Value, as formatter: Formatter<Value>) {
    formatter.format(value, into: self)
  }

  /// Prints a `Value` with a default formatter.
  ///
  /// - Parameter value: The value to print.
  @inlinable @inline(__always)
  public func print<Value: DefaultFormatterProvider>(_ value: Value) {
    print(value, as: Value.defaultFormatter)
  }

  /// Prints the specified value with the provided ``Formatter``.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The ``Formatter`` to format it with.
  @inlinable @inline(__always)
  public func println<T>(_ value: T, as formatter: Formatter<T>) {
    print(value, as: formatter)
    println()
  }

  /// Prints the specified value with the provided default formatter.
  ///
  /// - Parameter value: The value to print.
  @inlinable @inline(__always)
  public func println<T: DefaultFormatterProvider>(_ value: T) {
    print(value)
    println()
  }
}

// MARK: - Overrides to make life easier when providing single-character StaticString literals.

extension Printer {
  /// Prints a `StaticString`.
  ///
  /// - Parameter value: The `StaticString` to print.
  @inlinable @inline(__always)
  public func print(_ value: StaticString) {
    print(value, as: .staticString)
  }

  /// Prints a `StaticString` with a newline.
  ///
  /// - Parameter value: The `StaticString` to print.
  @inlinable @inline(__always)
  public func println(_ value: StaticString) {
    println(value, as: .staticString)
  }
}