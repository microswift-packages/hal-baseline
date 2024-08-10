/// An `OutputComparePin` is a physical digital pin that set to
/// `1` when an output comparison match occurs.
public protocol OutputComparePin {
  /// The type of the timer's counter value.
  associatedtype Value: FixedWidthInteger

  /// The type of the timer's clock select field.
  associatedtype ClockSelect: ClockSelectField

  /// Configures the pin to be in "Output Compare Match" mode.
  ///
  /// - Parameters:
  ///   - clock: The clock source/configuration for the timer.
  ///   - action: The action to take when a compare match occurs.
  @inlinable @inline(__always)
  static func configure(clock: ClockSelect, action: OutputComparePinAction<Value>)

  /// The effect that a compare match has on the output pin.
  @inlinable @inline(__always)
  static var effect: OutputComparePinEffect { get }

  /// The compare value.
  @inlinable @inline(__always)
  static var compareValue: Value { get }

    /// Attempts to force a compare match using the ``TimerChannel/compareValue``.
  /// Only works if the ``TimerChannel/timer`` is currently in an `immediate` update mode (ie. not PWM).
  ///
  /// - Returns: `true` if the compare match was forced, `false` otherwise.
  @inlinable @inline(__always)
  static func forceCompareMatch() -> Bool
}
