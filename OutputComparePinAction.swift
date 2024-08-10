/// Describes how the pin will behave when a compare match occurs.
public enum OutputComparePinAction<Value: FixedWidthInteger> {
  /// No action is taken.
  case none
  /// The output pin is toggled when the ``timer``'s ``TimerPeripheral/counter`` register matches the ``Counter`` value.
  case toggle(whenCounterIs: Value)
  /// The output pin is cleared when the ``timer``'s ``TimerPeripheral/counter`` register matches the ``Counter`` value.
  case clear(whenCounterIs: Value)
  /// The output pin is set when the ``timer``'s ``TimerPeripheral/counter`` register matches the ``Counter`` value.
  case `set`(whenCounterIs: Value)

  /// The effect that a compare match has on the output pin.
  @inlinable @inline(__always)
  public var outputPinEffect: OutputComparePinEffect {
    switch self {
    case .none:
      return .none
    case .toggle:
      return .toggleOnMatch
    case .clear:
      return .clearOnMatch
    case .set:
      return .setOnMatch
    }
  }

  /// The compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  public var compareValue: Value {
    switch self {
    case .none:
      return 0
    case .toggle(whenCounterIs: let value):
      return value
    case .clear(whenCounterIs: let value):
      return value
    case .set(whenCounterIs: let value):
      return value
    }
  }
}
