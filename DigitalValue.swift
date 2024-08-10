/// Represents a binary/digital value, which can be either `high` or `low`.
/// Most commonly used by ``DigitalPin``s.
public enum DigitalValue: UInt8, Equatable, Hashable {
  case high = 1
  case low = 0
}

extension DigitalValue {
  /// Performs a logical NOT operation on a DigitalValue.
  ///
  /// The logical NOT operator (`!`) inverts a DigitalValue. If the value is
  /// `high`, the result of the operation is `low`; if the value is `low`,
  /// the result is `high`.
  ///
  /// - Parameter a: The DigitalValue to negate.
  @inlinable @inline(__always)
  public static prefix func ! (lhs: DigitalValue) -> DigitalValue {
    switch lhs {
    case .high: return .low
    case .low: return .high
    }
  }
}

extension DigitalValue: CustomStaticStringConvertible {
  @inlinable @inline(__always)
  public var staticDescription: StaticString {
    switch self {
    case .high: return "HIGH"
    case .low: return "LOW"
    }
  }
}
