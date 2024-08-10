/// An implementation of using the TWI in "master" mode for transmitting or receiving from slave devices on a bus.
///
/// This implementation is based on the ATmega328P datasheet, section 21.5.1.
///
/// The TWI peripheral is a two-wire serial bus interface. It is compatible with Philips I2C protocol.
///
/// The TWI peripheral can operate in two modes: master and slave. In master mode, the TWI peripheral can operate in
/// either transmit or receive mode. In slave mode, the TWI peripheral can operate in either transmit or receive mode.
///
/// The TWI peripheral can operate in both master and slave mode simultaneously. The TWI peripheral can also operate
/// in both transmit and receive mode simultaneously.
public struct TwiMaster<Source: HasTwi> {
  public typealias Twi = Source.Twi

  /// Creates a new TwiMaster.
  ///
  /// - Parameter source: The TWI provider.
  @inlinable @inline(__always)
  public init(for source: Source.Type = Source.self) {}

  /// Configures the peripheral to operate in master mode.
  ///
  /// - Parameter clockFrequency: The clock frequency to use.
  @inlinable @inline(__always)
  public mutating func configure(clockFrequency: Frequency) {
    Twi.configureAsMaster(clockFrequency: clockFrequency)
  }

  /// Starts a transaction on the bus. The provided closure will be executed, then the transaction will be stopped.
  ///
  /// - Parameter transaction: The transaction to perform.
  /// - Returns: The failure that occurred, if any.
  @inlinable @inline(__always)
  public mutating func start(_ transaction: (inout TwiMasterTransaction<Source>) -> TwiFailure?)
    -> TwiFailure?
  {
    var masterTransaction = TwiMasterTransaction<Source>()

    return Twi.sendStartCondition() ?? transaction(&masterTransaction) ?? Twi.sendStopCondition()
  }
}

extension TwiMaster where Source: HasClockSpeed {
  /// Configures the peripheral to operate in master mode with the default clock frequency of the ``Source``.
  @inlinable @inline(__always)
  public mutating func configure() {
    configure(clockFrequency: Source.clockSpeed)
  }
}

public struct TwiMasterTransaction<Source: HasTwi> {
  public typealias Twi = Source.Twi

  /// Indicates whether the transaction should send a repeated start condition.
  @usableFromInline
  var repeated: Bool

  /// Initialises the transaction.
  ///
  /// - Parameter master: The TWI master.
  @inlinable @inline(__always)
  init(with source: Source.Type = Source.self) {
    repeated = false
  }

  /// Transmits data to a given slave `address`, using the `action` closure to send the data via the provided ``TwiMasterTransmit``.
  ///
  /// - Parameters:
  ///   - address: The address of the slave.
  ///   - action: The closure to use to send the data via the provided ``TwiMasterTransmit``.
  /// - Returns: The failure that occurred, if any.
  /// - Note: This function will send a start condition if this is the first time it has been called, or a repeated
  ///        start condition if it has been called before.
  @inlinable @inline(__always)
  public mutating func transmit(
    to address: TwiSlaveAddress, with action: (inout TwiMasterTransmit<Source>) -> TwiFailure?
  ) -> TwiFailure? {
    if repeated {
      if let failure = Twi.sendRepeatedStartCondition() {
        return failure
      }
    } else {
      repeated = true
    }
    var transmit = TwiMasterTransmit(to: address, with: Source.self)
    return action(&transmit)
  }

  /// Prepares to receive data from a given slave.
  ///
  /// - Parameters:
  ///   - address: The address of the slave.
  ///   - action: The action to perform to receive the data.
  /// - Returns: The failure that occurred, if any.
  /// - Note: This function will send a repeated start condition a ``transmit`` or ``receive`` function has been called before.
  @inlinable @inline(__always)
  public mutating func receive(
    from address: TwiSlaveAddress, with action: (inout TwiMasterReceive<Source>) -> TwiFailure?
  ) -> TwiFailure? {
    if repeated {
      if let failure = Twi.sendRepeatedStartCondition() {
        return failure
      }
    } else {
      repeated = true
    }
    var receive = TwiMasterReceive<Source>(from: address)
    return action(&receive)
  }

  /// Initiates a write to the specified register address on the slave.
  /// Data is sent to the slave using the provided closure.
  ///
  /// - Parameters:
  ///   - address: The register address to write to.
  ///   - slaveAddress: The address of the slave.
  ///   - action: The action to perform to send the data.
  /// - Returns: The failure that occurred, if any.
  @inlinable @inline(__always)
  public mutating func writeRegister(
    at address: TwiSlaveRegisterAddress, for slaveAddress: TwiSlaveAddress,
    with action: (inout TwiMasterTransmit<Source>) -> TwiFailure?
  ) -> TwiFailure? {
    transmit(to: slaveAddress) {
      $0.send(address.rawValue) ?? action(&$0)
    }
  }

  /// Writes the provided data to the specified register address on the slave.
  ///
  /// - Parameters:
  ///   - value: The data to write.
  ///   - address: The register address to write to.
  /// - Throws: If the data was not written.
  /// - Returns: The failure that occurred, if any.
  @inlinable @inline(__always)
  public mutating func writeRegister<V: RegisterValue>(
    value: V, at address: TwiSlaveRegisterAddress, for slaveAddress: TwiSlaveAddress
  ) -> TwiFailure? where V.RegisterType == UInt8 {
    writeRegister(at: address, for: slaveAddress) {
      $0.send(value.registerValue)
    }
  }

  /// Writes the provided ``RegisterValue`` to the specified register address on the slave.
  ///
  /// - Parameters:
  ///   - value: The data to write.
  ///   - address: The register address to write to.
  ///   - slaveAddress: The address of the slave.
  /// - Throws: If the data was not written.
  @inlinable @inline(__always)
  public mutating func writeRegister<V: RegisterValue>(
    value: V, at address: TwiSlaveRegisterAddress, for slaveAddress: TwiSlaveAddress
  ) -> TwiFailure? {
    writeRegister(at: address, for: slaveAddress) {
      // use MemoryLayout to get the size of the type in bytes
      let size = MemoryLayout<V.RegisterType>.size
      for i in 0..<size {
        if let failure = $0.send(UInt8((value.registerValue >> (i * 8)) & 0xFF)) {
          return failure
        }
      }
      return nil
    }
  }

  /// Initiates a read from the specified register address on the slave.
  /// Data is received from the slave using the provided closure.
  ///
  /// - Parameters:
  ///   - address: The register address to read from.
  ///   - slaveAddress: The address of the slave.
  ///   - action: The action to perform to receive the data.
  /// - Returns: The failure that occurred, if any.
  @inlinable @inline(__always)
  public mutating func readRegister(
    at address: TwiSlaveRegisterAddress, for slaveAddress: TwiSlaveAddress,
    with action: (inout TwiMasterReceive<Source>) -> TwiFailure?
  ) -> TwiFailure? {
    transmit(to: slaveAddress) { $0.send(address.rawValue) }
      ?? receive(from: slaveAddress, with: action)
  }
}

/// Provides functions for transmitting data to a slave.
public struct TwiMasterTransmit<Source: HasTwi> {
  public typealias Twi = Source.Twi

  /// The address of the slave.
  @usableFromInline
  let address: TwiSlaveAddress

  /// Creates a new TWITransmitAction.
  ///
  /// - Parameters:
  ///   - master: The TWI master.
  ///   - address: The address of the slave.
  ///   - repeated: Whether the transmission is repeated.
  @inlinable @inline(__always)
  public init(to address: TwiSlaveAddress, with source: Source.Type = Source.self) {
    self.address = address
  }

  /// Sends a single byte to the slave.
  ///
  /// - Parameter byte: The byte to send.
  /// - Throws: If the byte was not sent.
  @inlinable @inline(__always)
  public mutating func send(_ byte: UInt8) -> TwiFailure? {
    return Twi.sendByte(byte)
  }

  /// Sends multiple bytes to the slave.
  ///
  /// - Parameter bytes: The bytes to send.
  /// - Throws: If any of the bytes were not sent.
  @inlinable @inline(__always)
  public mutating func send<S: Sequence>(_ bytes: S) -> TwiFailure? where S.Element == UInt8 {
    for byte in bytes {
      if let failure = self.send(byte) {
        return failure
      }
    }
    return nil
  }

  /// Sends the specified range of bytes from an ``UnsafeBufferPointer`` to the slave.
  ///
  /// - Parameters:
  ///   - bytes: The buffer containing the bytes to send.
  ///   - startIndex: The index of the first byte to send.
  ///   - count: The maximum number of bytes to send. If `nil`, all bytes from `startingAt` to the end of the buffer
  ///           will be sent.
  /// - Returns: A ``TwiResult`` containing the number of bytes sent, or a failure.
  /// - Throws: If any of the bytes were not sent.
  @inlinable @inline(__always)
  @discardableResult
  public mutating func send(
    _ bytes: UnsafeBufferPointer<UInt8>, startingAt startIndex: Int = 0, atMost count: Int? = nil
  ) -> TwiResult<Int> {
    let count = min(bytes.count - startIndex, count ?? bytes.count - startIndex)
    for i in 0..<count {
      if let failure = self.send(bytes[startIndex + i]) {
        return .failure(failure)
      }
    }
    return .success(count)
  }
}

/// Provides functions for receiving data from a slave.
public struct TwiMasterReceive<Source: HasTwi> {
  public typealias Twi = Source.Twi

  /// The address of the slave.
  @usableFromInline
  let address: TwiSlaveAddress

  /// Creates a new TWIReceiveAction.
  ///
  /// - Parameters:
  ///   - address: The address of the slave.
  ///   - master: The TWI master.
  @usableFromInline
  init(from address: TwiSlaveAddress, with source: Source.Type = Source.self) {
    self.address = address
  }

  /// Receives a single byte from the slave.
  ///
  /// - Parameter acknowledge: Whether to send an ACK after receiving the byte. If `false`, a NACK will be sent.
  /// - Returns: The byte received.
  /// - Throws: If the byte was not received.
  @inlinable @inline(__always)
  public mutating func receive(acknowledge: Bool = true) -> TwiResult<UInt8> {
    Twi.receiveByte(acknowledge: acknowledge)
  }

  /// Receives the specified number of bytes from the slave into an ``UnsafeMutableBufferPointer``.
  ///
  /// - Parameters:
  ///   - bytes: The buffer to receive the bytes into.
  ///   - startIndex: The index of the first byte to receive.
  ///   - count: The maximum number of bytes to receive. If `nil`, all bytes from `startingAt` to the end of the buffer
  ///          will be received.
  /// - Returns: The number of bytes received, or a failure.
  @inlinable @inline(__always)
  @discardableResult
  public mutating func receive(
    into bytes: UnsafeMutableBufferPointer<UInt8>,
    startingAt startIndex: Int = 0,
    atMost count: Int? = nil
  ) -> TwiResult<Int> {
    let count = min(bytes.count - startIndex, count ?? bytes.count - startIndex)
    for i in 0..<count {
      switch self.receive(acknowledge: i < count - 1) {
      case .success(let byte):
        bytes[startIndex + i] = byte
      case .failure(let failure):
        return .failure(failure)
      }
    }
    return .success(count)
  }
}
