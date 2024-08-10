
/// A protocol for 8-bit synchronous timer peripherals. It provides a common interface for 8-bit timer peripherals,
/// with functions for configuring the timer and reading the current count.
public protocol TimerPeripheral {
  /// The counter register type.
  associatedtype Counter: FixedWidthInteger

  /// The ClockSelectField for the timer.
  associatedtype ClockSelect: ClockSelectField

  /// The interrupt type for the timer overflow.
  associatedtype OverflowInterrupt: Interrupt where OverflowInterrupt.Source == Self

  /// The counter register in its native size.
  @inlinable @inline(__always)
  static var counter: Counter { get }

  /// Defines the clock source for the timer.
  @inlinable @inline(__always)
  static var clock: ClockSelect { get }

  /// Configures the timer in 'normal' mode. In this mode, the timer simply counts up until it overflows.
  /// When it overflows, the ``overflowTriggered`` is set, and the timer starts counting from `0` again.
  /// If an interrupt is enabled for the overflow, the interrupt will be triggered as well.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModeNormal(clock: ClockSelect)

  /// Checks if the timer is currently in 'normal' mode.
  @inlinable @inline(__always)
  static var isModeNormal: Bool { get }
}

// TODO: Figure out what to do about the GTCCR (General Timer/Counter Control Register)
// It basically allows resetting the prescaler on either asynchronous or synchronous timers, or both.
// Its values are shared between all timers, so it doesn't necessarily make sense to have it here.
