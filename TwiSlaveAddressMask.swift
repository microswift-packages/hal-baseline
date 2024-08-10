/// A 7-bit address mask for the ``TwiPeripheral``.
///
/// This is used to determine which bits of the slave address are used for matching.
/// The default value is `0b0000000`, which means that all bits must match.
/// Any `1` bit in the mask means that the corresponding bit will be ignored.
///
/// For example, the MPU-6050 has a slave address of `0b1101000`. It has an alternate address of `0b1101001`.
/// If the slave address mask is `0b0000001`, then either address will match.
public struct TwiSlaveAddressMask: RegisterValue, Equatable {
  /// The bitfield's raw value.
  public var registerValue: UInt8

  /// Initializes the register with its raw value. Only the lower 7 bits are used.
  ///
  /// - Parameter value: The raw value of the register.
  @inlinable @inline(__always)
  public init(_ value: UInt8) {
    self.registerValue = value & 0b0111_1111
  }

  /// Initializes the register with its raw value. Only the lower 7 bits are used.
  ///
  /// - Parameter value: The raw value of the register.
  @inlinable @inline(__always)
  public init(registerValue value: UInt8) {
    self.init(value)
  }
}

extension TwiSlaveAddressMask {
  /// Require the given address bits to match (`0`). This is the default.
  public static let exactMatch = Self(0b00000000)
}