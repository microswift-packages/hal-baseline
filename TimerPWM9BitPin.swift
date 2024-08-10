/// A 9-bit extension of ``PWMPin`` for ``Timer16BitPeripheral``s.
public protocol TimerPWM9BitPin: PWMPin, HasPWM9BitPin where Value == UInt16
{
  /// The ``Timer8BitChannel`` type that this pin is linked to.
  associatedtype Channel: Timer16BitChannel & TimerChannelWithPin
    where Channel.Timer: TimerFastPWM9BitConfigurable,
          Channel.Timer.ClockSelect == Self.ClockSelect

  /// The ``PortPeripheral`` type that this pin is linked to.
  associatedtype Port: PortPeripheral

  /// The ``Timer8BitPeripheral`` that this pin is linked to.
  typealias Timer = Channel.Timer

  /// The pin number on the port.
  @inlinable @inline(__always)
  static var portPin: UInt8 { get }
}

extension TimerPWM9BitPin {
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
  public static func configure(clock: Channel.Timer.ClockSelect, initialValue: UInt16) {
    Port.direction.setBit(at: Self.portPin, to: true)
    Channel.outputPinEffect = .clearOnMatch
    Channel.compareValue16 = initialValue
    Timer.configureModeFastPWM9Bit(clock: clock)
  }

  /// The duty cycle value. This is continuously compared to the ``timer``'s ``Timer8Bit/counter`` register based on the
  /// ``timer``'s mode, and the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  public static var value: UInt16 {
    get { .init(Channel.compareValue) }
    set { Channel.compareValue = .init(newValue) }
  }
}