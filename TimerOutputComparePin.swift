// An extension of ``OutputComparePin`` that connected to a ``TimerPeripheral`` instance.

public protocol TimerOutputComparePin: OutputComparePin {
  /// The ``Timer8BitChannel`` type that this pin is connected to.
  associatedtype Channel: TimerChannelWithPin
  where
    Channel.Counter == Value,
    Channel.Timer.ClockSelect == ClockSelect

  /// The ``PortPeripheral`` type associated with this value.
  associatedtype Port: PortPeripheral

  /// The ``Timer8BitPeripheral`` type that this pin is connected to.
  typealias Timer = Channel.Timer

  /// The pin number on the port.
  static var portPin: UInt8 { get }
}

extension TimerOutputComparePin {
  /// Configures the pin to be in "Output Compare Match" mode.
  ///
  /// - Parameter action: The action to take when a compare match occurs.
  @inlinable @inline(__always)
  public static func configure(clock: ClockSelect, action: OutputComparePinAction<Value>) {
    Port.direction.setBit(at: self.portPin, to: true)
    Channel.outputPinEffect = action.outputPinEffect
    Timer.configureModeCTC(clock: clock, top: action.compareValue)
  }

  /// The compare value. This is continuously compared to the ``timer``'s ``Timer8Bit/counter`` register based on the
  /// ``timer``'s mode, and the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  public static var compareValue: Value {
    Channel.compareValue
  }

  /// The effect that a compare match has on the output pin.
  @inlinable @inline(__always)
  public static var effect: OutputComparePinEffect {
    Channel.outputPinEffect
  }

  /// Attempts to force a compare match using the ``TimerChannel/compareValue``.
  /// Only works if the ``TimerChannel/timer`` is currently in an `immediate` update mode (ie. not PWM).
  ///
  /// - Returns: `true` if the compare match was forced, `false` otherwise.
  @inlinable @inline(__always)
  public static func forceCompareMatch() -> Bool {
    Channel.forceCompareMatch()
  }
}
