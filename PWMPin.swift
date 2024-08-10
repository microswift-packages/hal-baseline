/// A `PWMPin` is a physical pin that can be used as a PWM output.
/// This simulates analog output by rapidly toggling the pin between `1` and `0` with a
/// specific duty cycle.
///
/// When configuring the pin, you specify what clock source to use for the timer, and
/// the ``timer``'s ``Timer/counter`` register is used as the period. The ``value`` property
/// is continuously compared to the ``timer``'s ``Timer/counter`` register based on the
/// ``timer``'s mode, and the ``timer``'s output is toggled depending on the ``outputPinEffect``.
///
/// In practice, once you have configured the pin, you can set the ``value`` property to
/// a value between `0` and `255` to set the duty cycle. A value of `0` will result in a
/// duty cycle of `0%`, and a value of `255` will result in a duty cycle of `100%`.
public protocol PWMPin {
  /// The type of value that is compared against.
  associatedtype Value: UnsignedInteger

  /// The ClockSelectField that is used to configure the timer.
  associatedtype ClockSelect: ClockSelectField

  /// Configures the pin to be in "Output Compare Match" mode.
  ///
  /// - Parameters:
  ///   - clock: The clock source/configuration for the timer.
  ///   - initialValue: The initial duty cycle value.
  static func configure(clock: ClockSelect, initialValue: Value)

  /// The duty cycle value. This is continuously compared to the ``timer``'s ``Timer/counter`` register based on the
  /// ``timer``'s mode, and the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  static var value: Value { get set }
}
