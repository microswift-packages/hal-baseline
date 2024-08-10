// Adds support for formatting unsigned integers.

/// Specifies a separator for grouping digits, along with the number of digits between each separator.
public struct DigitGrouping {
  /// The separator character to use.
  public let character: UInt8

  /// The number of digits between each separator.
  public let count: UInt8

  /// Creates a new digit separator.
  ///
  /// - Parameter separator: The separator to use.
  /// - Parameter every: The number of digits between each separator.
  /// - Note: A `count` of `0` disables grouping.
  @inlinable @inline(__always)
  public init(character: UInt8, every count: UInt8) {
    self.character = character
    self.count = count
  }

  /// A digit separator with no separator and no grouping.
  @inlinable @inline(__always)
  public static var none: DigitGrouping {
    DigitGrouping(character: 0, every: 0)
  }

  /// A digit separator with a space separator every `count` digits.
  ///
  /// - Parameter count: The number of digits between each separator.
  @inlinable @inline(__always)
  public static func space(every count: UInt8) -> DigitGrouping {
    DigitGrouping(character: 0x20, every: count)
  }

  /// A digit separator with a comma separator every `count` digits.
  ///
  /// - Parameter count: The number of digits between each separator.
  @inlinable @inline(__always)
  public static func comma(every count: UInt8) -> DigitGrouping {
    DigitGrouping(character: 0x2C, every: count)
  }

  /// A digit separator with an underscore separator every `count` digits.
  ///
  /// - Parameter count: The number of digits between each separator.
  @inlinable @inline(__always)
  public static func underscore(every count: UInt8) -> DigitGrouping {
    DigitGrouping(character: 0x5F, every: count)
  }

  /// A digit separator with a period separator every `count` digits.
  ///
  /// - Parameter every: The number of digits between each separator.
  @inlinable @inline(__always)
  public static func period(every count: UInt8) -> DigitGrouping {
    DigitGrouping(character: 0x2E, every: count)
  }

  /// A digit seprator with a custom separator every `count` digits.
  ///
  /// - Parameter character: The separator to use.
  /// - Parameter count: The number of digits between each separator.
  @inlinable @inline(__always)
  public static func with(_ character: UInt8, every count: UInt8) -> DigitGrouping {
    DigitGrouping(character: character, every: count)
  }
}

extension Formatter where Value: UnsignedInteger & FixedWidthInteger {
  /// Creates a new formatter for unsigned integers.
  ///
  /// - Parameter radix: The radix to use for formatting.
  /// - Parameter uppercase: Whether to use uppercase letters for the digits. (default: true)
  /// - Parameter grouping: The digit grouping to use. (default: none)
  /// - Parameter minimumDigits: The minimum number of digits to use. (default: 1)
  @inlinable @inline(__always)
  public static func unsignedInteger(
    radix: UInt8 = 10, uppercase: Bool = true, grouping: DigitGrouping = .none,
    minimumDigits: UInt8 = 1
  ) -> Formatter<Value> {
    Formatter<Value> { value, printer in
      func printLowestDigit(_ value: Value, radix: Value) {
        let digit = value % radix
        let char =
          digit < 10
          ? UInt8(truncatingIfNeeded: digit) + 0x30
          : UInt8(truncatingIfNeeded: digit) + (uppercase ? 0x37 : 0x57)
        printer.writeByte(char)
      }

      func printUpperDigits(_ value: Value, radix: Value, printedDigits: UInt8) {
        let upperValue = value / radix
        let printedDigits = printedDigits + 1
        if minimumDigits > printedDigits || upperValue > 0 {
          printUpperDigits(upperValue, radix: radix, printedDigits: printedDigits)
          if grouping.count > 0 && printedDigits != 0 && printedDigits % grouping.count == 0 {
            printer.writeByte(grouping.character)
          }
        }
        printLowestDigit(value, radix: radix)
      }

      printUpperDigits(value, radix: Value(truncatingIfNeeded: radix), printedDigits: 0)
    }
  }

  /// Optimised formatter for unsigned integers with radix 10, no grouping, and no minimum digits.
  @inlinable @inline(__always)
  public static var decimal: Formatter<Value> {
    Formatter<Value> { value, printer in
      func printLowestDigit(_ value: Value) {
        let digit = value % 10
        let char = UInt8(truncatingIfNeeded: digit) + 0x30
        printer.writeByte(char)
      }

      func printUpperDigits(_ value: Value) {
        let upperValue = value / 10
        if upperValue > 0 {
          printUpperDigits(upperValue)
        }
        printLowestDigit(value)
      }

      printUpperDigits(value)
    }
  }

  /// Creates a new formatter for unsigned integers in hexadecimal `0x00` format, with uppercase letters.
  @inlinable @inline(__always)
  public static var hexadecimal: Formatter<Value> {
    let minimumDigits = UInt8(truncatingIfNeeded: Value.bitWidth / 4)

    return Formatter { value, printer in
      func printLowestDigit(_ value: Value) {
        let digit = value % 16
        let char = UInt8(truncatingIfNeeded: digit) + (digit < 10 ? 0x30 : 0x37)
        printer.writeByte(char)
      }

      func printUpperDigits(_ value: Value, printedDigits: UInt8) {
        let upperValue = value / 16
        let printedDigits = printedDigits + 1
        if printedDigits < minimumDigits || upperValue > 0 {
          printUpperDigits(upperValue, printedDigits: printedDigits)
          if printedDigits != 0 && printedDigits % 4 == 0 {
            printer.writeByte(0x5F)  // _
          }
        }
        printLowestDigit(value)
      }

      printer.writeByte(0x30)  // 0
      printer.writeByte(0x78)  // x
      printUpperDigits(value, printedDigits: 0)
    }
  }

  /// Creates a new formatter for unsigned integers in binary `0b0000_0000` format.
  @inlinable @inline(__always)
  public static var binary: Formatter<Value> {
    let minimumDigits = UInt8(truncatingIfNeeded: Value.bitWidth)

    return Formatter { value, printer in
      func printLowestDigit(_ value: Value) {
        let digit = value % 2
        let char = UInt8(truncatingIfNeeded: digit) + 0x30
        printer.writeByte(char)
      }

      func printUpperDigits(_ value: Value, printedDigits: UInt8) {
        let upperValue = value / 2
        let printedDigits = printedDigits + 1
        if minimumDigits > printedDigits || upperValue > 0 {
          printUpperDigits(upperValue, printedDigits: printedDigits)
          if printedDigits != 0 && printedDigits % 4 == 0 {
            printer.writeByte(0x5F)  // _
          }
        }
        printLowestDigit(value)
      }

      printer.writeByte(0x30)  // 0
      printer.writeByte(0x62)  // b
      printUpperDigits(value, printedDigits: 0)
    }
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to unsigned integers.
extension UInt: DefaultFormatterProvider {
  /// The default formatter for unsigned integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to 8-bit unsigned integers.
extension UInt8: DefaultFormatterProvider {
  /// The default formatter for unsigned integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to 16-bit unsigned integers.
extension UInt16: DefaultFormatterProvider {
  /// The default formatter for unsigned integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to 32-bit unsigned integers.
extension UInt32: DefaultFormatterProvider {
  /// The default formatter for unsigned integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}

/// Adds ``DefaultFormatterProvider`` conformance to 64-bit unsigned integers.
extension UInt64: DefaultFormatterProvider {
  /// The default formatter for unsigned integers.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.decimal
  }
}
