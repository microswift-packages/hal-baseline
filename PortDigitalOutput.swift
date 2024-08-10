/// Implementation of DigitalOutput for PortPeripherals.
public protocol PortDigitalOutput: DigitalOutput {
  /// The ``PortPeripheral`` that this pin is connected to.
  associatedtype Port: PortPeripheral

  /// The bit of the port that this pin is on.
  @inlinable @inline(__always)
  static var bit: UInt8 { get }
}

extension PortDigitalOutput {
  /// Configures the pin as an output with the specified initial value.
  ///
  /// - Parameter initialValue: The initial value of the pin.
  @inlinable @inline(__always)
  public static func configure(initialValue: DigitalValue) {
    Port.direction.setBit(at: bit, to: true)
    Port.data.setBit(at: bit, to: initialValue == .high)
  }

  /// Sets the value of the pin.
  @inlinable @inline(__always)
  public static var value: DigitalValue {
    @inlinable @inline(__always) get { Port.data.hasBit(at: bit) ? .high : .low }
    @inlinable @inline(__always) set { Port.data.setBit(at: bit, to: newValue == .high) }
  }

  /// Flip the value of the output pin.
  @inlinable @inline(__always)
  public static func toggle() {
    Port.data.toggleBit(at: bit)
  }
}