/// An extension of ``DigitalInput`` for pins which are part of a ``PortPeripheral`` configured as an input.
public protocol PortDigitalInput: DigitalInput {
  /// The ``PortPeripheral`` that this pin is connected to.
  associatedtype Port: PortPeripheral

  /// The bit of the port that this pin is on.
  @inlinable @inline(__always)
  static var bit: UInt8 { get }
}

extension PortDigitalInput {
  /// Configures the pin as an input with the specified pull-up resistor state.
  ///
  /// - Parameter pullup: The pull-up resistor state of the pin.
  @inlinable @inline(__always)
  public static func configure(pullup: PullupState) {
    Port.direction.setBit(at: bit, to: false)
    Port.data.setBit(at: bit, to: pullup == .enabled)
  }

  /// The pull-up resistor state of the pin.
  @inlinable @inline(__always)
  public static var pullup: PullupState {
    @inlinable @inline(__always) get { Port.data.hasBit(at: bit) ? .enabled : .disabled }
    @inlinable @inline(__always) set { Port.data.setBit(at: bit, to: newValue == .enabled) }
  }

  /// The value of the pin.
  @inlinable @inline(__always)
  public static var value: DigitalValue {
    @inlinable @inline(__always) get { Port.input.hasBit(at: bit) ? .high : .low }
  }
}