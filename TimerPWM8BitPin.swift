/// An extension of ``PWMPin`` for ``Timer8BitPeripheral``s.
public protocol TimerPWM8BitPin: PWMPin, HasPWM8BitPin where Value == UInt8
{
  /// The ``Timer8BitChannel`` type that this pin is linked to.
  associatedtype Channel: Timer8BitChannel & TimerChannelWithPin
    where Channel.Timer: TimerFastPWM8BitConfigurable,
          Channel.Timer.ClockSelect == Self.ClockSelect

  /// The ``PortPeripheral`` type that this pin is linked to.
  associatedtype Port: PortPeripheral

  /// The ``Timer8BitPeripheral`` that this pin is linked to.
  typealias Timer = Channel.Timer

  /// The pin number on the port.
  @inlinable @inline(__always)
  static var portPin: UInt8 { get }
}

extension TimerPWM8BitPin {
  /// Configures the pin to be in "PWM" mode.
  ///
  /// This uses "Fast PWM" mode, and clears the output on match. This should result in a duty cycle that is
  /// proportional to the ``value``: if the ``value`` is 0, the output on 0% of the time; if the ``value`` is the
  /// ``PWMPin/Value/max``, the output will be 100% of the time.
  ///
  /// - Parameters:
  ///   - clock: The clock source/configuration for the timer.
  ///   - initialValue: The initial value of the duty cycle.
  @inlinable @inline(__always)
  public static func configure(clock: Channel.Timer.ClockSelect, initialValue: UInt8) {
    Port.direction.setBit(at: Self.portPin, to: true)
    Channel.outputPinEffect = .clearOnMatch
    Channel.compareValue8 = initialValue
    Timer.configureModeFastPWM8Bit(clock: clock)
  }

  /// The duty cycle value. This is continuously compared to the ``timer``'s ``Timer8Bit/counter`` register based on the
  /// ``timer``'s mode, and the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static public var value: UInt8 {
    get { UInt8(Channel.compareValue) }
    set { Channel.compareValue = .init(newValue) }
  }
}