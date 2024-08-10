/// Represents a SLA+R or SLA+W address for the ``TwiPeripheral``.
///
/// This is used to send data to or receive data from a slave device.
public struct TwiSlaveAddressRW: RegisterValue, Equatable {
  /// Indicates whether the address is for reading or writing.
  public enum ReadWrite: UInt8, Equatable {
    /// The address is for reading.
    case read = 1

    /// The address is for writing.
    case write = 0
  }

  /// The bitfield's raw value.
  public let registerValue: UInt8

  /// Initializes the register with its raw value. Only the lower 7 bits are used.
  ///
  /// - Parameter value: The raw value of the register.
  @inlinable @inline(__always)
  public init(address: TwiSlaveAddress, _ readWrite: ReadWrite) {
    self.registerValue = address.rawValue << 1 | readWrite.rawValue
  }

  /// Initializes the register with its raw value. The upper 7 bits are the address, and the lower bit is the read/write bit.
  ///
  /// - Parameter value: The raw value of the register.
  @inlinable @inline(__always)
  public init(registerValue value: UInt8) {
    self.registerValue = value
  }

  /// Retrieve the address from the register.
  @inlinable @inline(__always)
  public var address: TwiSlaveAddress {
    .init(integerLiteral: registerValue >> 1)
  }

  /// Retrieve the read/write bit from the register.
  @inlinable @inline(__always)
  public var readWrite: ReadWrite {
    .init(rawValue: registerValue & 0b1)!
  }
}