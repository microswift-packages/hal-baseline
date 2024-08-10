/// Add ``Formatter`` conformance to `SignedInteger` types.
extension Formatter
where Value: SignedInteger, Value.Magnitude: UnsignedInteger & FixedWidthInteger {
  /// Creates a new formatter for signed integers.
  ///
  /// - Parameter radix: The radix to use for formatting. (default: 10)
  /// - Parameter uppercase: Whether to use uppercase letters for digits greater than 9. (default: true)
  /// - Parameter grouping: The digit grouping to use. (default: none)
  /// - Parameter minimumDigits: The minimum number of digits to use. (default: 1)
  @inlinable @inline(__always)
  public static func signedInteger(
    radix: UInt8 = 10, uppercase: Bool = true, grouping: DigitGrouping = .none,
    minimumDigits: UInt8 = 1
  ) -> Formatter<Value> {
    Formatter<Value> { value, printer in
      if radix == 10 && value < 0 {
        printer.writeByte(0x2D)
        printer.print(
          Value.Magnitude(truncatingIfNeeded: -value),
          as: .unsignedInteger(
            radix: radix, uppercase: uppercase, grouping: grouping, minimumDigits: minimumDigits)
        )
      } else {
        printer.print(
          Value.Magnitude(truncatingIfNeeded: value),
          as: .unsignedInteger(
            radix: radix, uppercase: uppercase, grouping: grouping, minimumDigits: minimumDigits)
        )
      }
    }
  }

  /// Creates a new formatter for signed integers with radix 10.
  @inlinable @inline(__always)
  public static var decimal: Formatter<Value> {
    Formatter<Value> { value, printer in
      if value < 0 {
        printer.writeByte(0x2D)
        printer.print(Value.Magnitude(truncatingIfNeeded: -value), as: .decimal)
      } else {
        printer.print(Value.Magnitude(truncatingIfNeeded: value), as: .decimal)
      }
    }
  }

  /// Creates a new formatter for signed integers in hexadecimal notation. Eg. `0x1A`.
  @inlinable @inline(__always)
  public static var hexadecimal: Formatter<Value> {
    Formatter { value, printer in
      printer.print(Value.Magnitude(truncatingIfNeeded: value), as: .hexadecimal)
    }
  }

  /// Creates a new formatter for signed integers with binary digits. Eg. `0b0001010`.
  @inlinable @inline(__always)
  public static var binary: Formatter<Value> {
    Formatter { value, printer in
      printer.print(Value.Magnitude(truncatingIfNeeded: value), as: .binary)
    }
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to signed integers.
extension SignedInteger where Magnitude: UnsignedInteger & FixedWidthInteger {
  /// The default formatter for signed integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to signed integers.
extension Int: DefaultFormatterProvider {}

/// Adds ``DefaultFormatterProvider`` conformance to 8-bit signed integers.
extension Int8: DefaultFormatterProvider {}

/// Adds ``DefaultFormatterProvider`` conformance to 16-bit signed integers.
extension Int16: DefaultFormatterProvider {}

/// Adds ``DefaultFormatterProvider`` conformance to 32-bit signed integers.
extension Int32: DefaultFormatterProvider {}

/// Adds ``DefaultFormatterProvider`` conformance to 64-bit signed integers.
extension Int64: DefaultFormatterProvider {}
