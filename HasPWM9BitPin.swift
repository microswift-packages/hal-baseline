/// A protocol that indicates a type has a 9-bit ``PWMPin`` linked to it.
public protocol HasPWM9BitPin {
  associatedtype PWM9: PWMPin where PWM9.Value == UInt16
}
