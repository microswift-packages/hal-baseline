/// Represents a PORT peripheral.
public protocol PortPeripheral {
  /// The type of the data register.
  associatedtype DataRegister: MutableRegisterValue

  /// The type of the data direction register.
  associatedtype DataDirectionRegister: MutableRegisterValue

  /// The type of the input register.
  associatedtype InputRegister: MutableRegisterValue

  /// The data register.
  @inlinable @inline(__always)
  static var data: DataRegister { get set }

  /// The data direction register.
  @inlinable @inline(__always)
  static var direction: DataDirectionRegister { get set }

  /// The input register.
  @inlinable @inline(__always)
  static var input: InputRegister { get set }
}
