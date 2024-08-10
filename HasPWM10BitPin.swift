/// A protocol that indicates a type has a 10-bit ``PWMPin`` linked to it.
public protocol HasPWM10BitPin {
  /// The 10-bit ``PWMPin``.
  associatedtype PWM10: PWMPin where PWM10.Value == UInt16
}
