/// The prescaler for the ADC clock.
/// The higher the prescaler, the lower the ADC clock frequency.
public enum AdcPrescaler: UInt8, Bitfield, CaseIterable {
  case divideBy2 = 0x0
  case divideBy4 = 0x2
  case divideBy8 = 0x3
  case divideBy16 = 0x4
  case divideBy32 = 0x5
  case divideBy64 = 0x6
  case divideBy128 = 0x7

  /// The divisor value for the prescaler.
  @inlinable @inline(__always)
  var divisor: UInt8 {
    switch self {
    case .divideBy2: return 2
    case .divideBy4: return 4
    case .divideBy8: return 8
    case .divideBy16: return 16
    case .divideBy32: return 32
    case .divideBy64: return 64
    case .divideBy128: return 128
    }
  }

  /// Returns the best available prescaler for the given clock speed and target ADC frequency.
  /// - Parameters:
  ///   - clockSpeed: The clock speed of the ADC peripheral.
  ///   - targetAdcFrequency: The target Adc frequency.
  /// - Returns: The best available prescaler.
  @inlinable @inline(__always)
  static func bestAvailable(clockSpeed: Frequency, targetAdcFrequency: Frequency) -> Self {
    // calculate it without using doubles:
    let minPrescaler = clockSpeed.hertz / targetAdcFrequency.hertz
    for prescaler in Self.allCases {
      if prescaler.divisor >= minPrescaler {
        return prescaler
      }
    }
    // Fallback to the maximum prescaler value if none of the available prescalers meet the requirements
    return Self.allCases.last!
  }
}
