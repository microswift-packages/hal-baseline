/// A protocol that indicates a type has an 8-bit ``PWMPin`` linked to it.
public protocol HasPWM8BitPin {
  /// The 8-bit ``PWMPin``.
  associatedtype PWM8: PWMPin where PWM8.Value == UInt8
}

extension HasPWM8BitPin where Self: PWMPin, Self.Value == UInt8 {
  /// The 8-bit ``PWMPin`` associates with itself.
  public typealias PWM8 = Self
}
