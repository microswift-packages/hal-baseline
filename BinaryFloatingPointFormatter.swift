/// Prints a Float value to the UART peripheral.
///
/// - Parameter value: The value to write.
// @inlinable @inline(__always)
// mutating public func print<F: BinaryFloatingPoint>(_ value: F) {
//   // Print the sign.
//   if value < 0 {
//     self.writeByte(0x2D)
//   }
//   // Print the integer part.
//   var integerPart = UInt64(value)
//   var divisor: UInt64 = 1
//   while integerPart / divisor >= 10 {
//     divisor *= 10
//   }
//   while divisor > 0 {
//     let digit = integerPart / divisor
//     self.writeByte(UInt8(digit) + 0x30)
//     integerPart -= digit * divisor
//     divisor /= 10
//   }
//   // Print the decimal point.
//   self.writeByte(0x2E)
//   // Print the fractional part.
//   var fractionalPart = value - F(integerPart)
//   for _ in 0..<6 {
//     fractionalPart *= 10
//     let digit = UInt8(fractionalPart)
//     self.writeByte(digit + 0x30)
//     fractionalPart -= F(digit)
//   }
// }

/// Adds ``Formatter`` support for ``BinaryFloatingPoint``.
extension Formatter where Value: BinaryFloatingPoint {
  /// Creates a new formatter for ``BinaryFloatingPoint``.
  ///
  /// - Parameter precision: The number of digits to print after the decimal point. (default: 6)
  /// - Parameter grouping: The digit grouping to use. (default: none)
  @inlinable @inline(__always)
  public static func floatingPoint(
    precision: UInt8 = 6, grouping: DigitGrouping = .none
  ) -> Formatter<Value> {
    Formatter<Value> { value, printer in
      // Print the sign.
      if value < 0 {
        printer.writeByte(0x2D)  // "-"
      }
      // Print the integer part.
      let absValue = abs(value)

      guard precision > 0 else {
        printer.print(UInt64(absValue.rounded()), as: .unsignedInteger(grouping: grouping))
        return
      }

      let integerPart = UInt64(absValue)
      var fractionalPart = absValue - Value(integerPart)

      printer.print(integerPart, as: .unsignedInteger(grouping: grouping))

      // Print the decimal point.
      printer.writeByte(0x2E)  // "."

      // Print the fractional part.
      for _ in 1..<precision {
        let digit = UInt8(fractionalPart * 10)
        fractionalPart = fractionalPart * 10 - Value(digit)
        printer.writeByte(digit + 0x30)
      }

      // Round the last digit.
      let digit = UInt8((fractionalPart * 10).rounded())
      printer.writeByte(digit + 0x30)
    }
  }
}

// Adds ``DefaultFormatterProvider`` conformance to ``BinaryFloatingPoint``.
extension DefaultFormatterProvider where Self: BinaryFloatingPoint {
  /// The default formatter for ``BinaryFloatingPoint``.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.floatingPoint()
  }
}

// MARK: Conformance

extension Float: DefaultFormatterProvider {}

extension Float16: DefaultFormatterProvider {}
