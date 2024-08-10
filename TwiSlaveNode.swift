/// Represents a connection to an TWI slave node (a.k.a. a device attached to the TWI bus).
/// It has a `TwiSlaveAddress` and provides support methods for reading and writing to the device at that address.
public protocol TwiSlaveNode {
  associatedtype Twi: TwiPeripheral

  /// The slave address for the device.
  var address: TwiSlaveAddress { get }
}

// MARK: - Reading

// Adds support methods for read/write to the slave node.
extension TwiSlaveNode {
  /// Sends an SLA+W followed by a slave register address.
  ///
  /// - Parameter register: The register number to write to.
  /// - Returns: `nil` if the byte was sent, otherwise a `TwiFailure`.
  @inlinable @inline(__always)
  public mutating func sendRegisterAddress(_ register: TwiSlaveRegisterAddress) -> TwiFailure? {
    Twi.sendSlaveAddressWrite(for: address)
      ?? Twi.sendByte(register)
  }

  /// Prepares the bus to send bytes to the slave node.
  ///
  /// - Parameter register: The register number to write to.
  /// - Returns: `nil` if the byte was sent, otherwise a `TwiFailure`.
  @inlinable @inline(__always)
  public mutating func prepareToSendBytes(to register: TwiSlaveRegisterAddress) -> TwiFailure? {
    Twi.sendStartCondition()
      ?? sendRegisterAddress(register)
  }

  /// Prepares the bus to receive bytes from the slave node.
  ///
  /// - Parameter register: The register number to read from.
  /// - Returns: `nil` if the byte was sent, otherwise a `TwiFailure`.
  @inlinable @inline(__always)
  public mutating func prepareToReceiveBytes(from register: TwiSlaveRegisterAddress) -> TwiFailure?
  {
    Twi.sendStartCondition()
      ?? sendRegisterAddress(register)
      ?? Twi.sendRepeatedStartCondition()
      ?? Twi.sendSlaveAddressRead(for: address)
  }

  /// Reads a single byte ``RegisterValue`` from the specified register address.
  ///
  /// - Parameter register: The register number to read from.
  /// - Returns: The byte read from the register.
  @inlinable @inline(__always)
  public mutating func readValue<T: RegisterValue>(
    from register: TwiSlaveRegisterAddress, as: T.Type = T.self
  ) -> TwiResult<T> where T.RegisterType.Magnitude == UInt8 {
    // Prepare the bus to receive bytes from the register.
    if let failure = prepareToReceiveBytes(from: register) {
      return .failure(failure)
    }

    // Try receiving the byte.
    switch Twi.receiveByte() {
    case .success(let byte):
      if let failure = Twi.sendStopCondition() {
        return .failure(failure)
      }

      return .success(T(registerValue: T.RegisterType(truncatingIfNeeded: byte)))
    case .failure(let failure):
      return .failure(failure)
    }
  }

  /// Reads a ``RegisterValue`` from the specified register range.
  /// All registers in the range will be read. The highest register in the range will
  /// map to the least significant byte of the ``RegisterValue``.
  /// If the number of registers in the range is greater than the size of the
  /// ``RegisterValue``, the lowest register bytes are ignored.
  ///
  /// - Parameter registers: The range of registers to read from.
  /// - Parameter as: The ``RegisterValue`` type to read. Defaults to `T.self`.
  /// - Returns: A ``TwiResult`` containing the value as the specified ``RegisterValue``, or a ``TwiFailure``.
  @inlinable @inline(__always)
  public mutating func readValue<T: RegisterValue>(
    from registers: ClosedRange<TwiSlaveRegisterAddress>, as: T.Type = T.self
  ) -> TwiResult<T> {
    // Prepare the bus to receive bytes from the register.
    if let failure = prepareToReceiveBytes(from: registers.lowerBound) {
      return .failure(failure)
    }

    // Determine the number of bytes based on the type stride.
    let registerCount = registers.count

    // Read all bytes unsigned.
    var value: T.RegisterType.Magnitude = 0

    // Read the bytes.
    for i in 0..<registerCount {
      switch Twi.receiveByte(acknowledge: i < registerCount - 1) {
      case .success(let byte):
        // shift the value by 8 bits, and add the new byte.
        value = value << 8 | T.RegisterType.Magnitude(truncatingIfNeeded: byte)
      case .failure(let failure):
        return .failure(failure)
      }
    }

    if let failure = Twi.sendStopCondition() {
      return .failure(failure)
    }

    return .success(T(registerValue: T.RegisterType(truncatingIfNeeded: value)))
  }

  /// Reads sequential bytes from the register range, copying them into the provided `UInt8` buffer.
  /// The lowest register will be written to the `start` index in the buffer.
  /// All registers in the range will be read, even if the buffer is not large enough to hold them all. Extra bytes are discarded.
  ///
  /// - Parameter registers: The closed range of register addresses to retrieve bytes from.
  /// - Parameter buffer: The buffer to copy the bytes into.
  /// - Parameter start: The starting index in the buffer to copy bytes into. (defaults to `0`)
  /// - Returns: `nil` if the bytes were read, otherwise a `TwiFailure`.
  /// - Note: Not all chipsets support reading sequential registers.
  @inlinable @inline(__always)
  public mutating func readBytes(
    from registers: ClosedRange<TwiSlaveRegisterAddress>,
    into buffer: UnsafeMutableBufferPointer<UInt8>,
    startingAt start: UnsafeMutableBufferPointer<UInt8>.Index = 0
  ) -> TwiFailure? {
    let availableBytes = buffer.count - start

    if let failure = prepareToReceiveBytes(from: registers.lowerBound) {
      return failure
    }

    for i in 0..<registers.count {
      switch Twi.receiveByte(acknowledge: i < registers.count - 1) {
      case .success(let byte):
        if i < availableBytes {
          buffer[start + i] = byte
        }
      case .failure(let failure):
        return failure
      }
    }

    return Twi.sendStopCondition()
  }

  /// Reads sequential bytes from the register range, adding them to the provided buffer, up to the buffer's capacity.
  /// The lowest register will be written to the `start` index in the buffer.
  /// All registers in the range will be read, even if the buffer is not large enough to hold them all. Extra bytes are discarded.
  ///
  /// - Parameter registers: The closed range of register addresses to retrieve bytes from.
  /// - Parameter buffer: The buffer to copy the bytes into.
  /// - Parameter start: The starting index in the buffer to copy bytes into. (defaults to `0`)
  /// - Returns: `nil` if the bytes were read, otherwise a `TwiFailure`.
  /// - Note: Not all chipsets support reading sequential registers.
  @inlinable @inline(__always)
  public mutating func readBytes(
    from registers: ClosedRange<TwiSlaveRegisterAddress>,
    into buffer: UnsafeMutableRawBufferPointer,
    startingAt start: UnsafeMutableRawBufferPointer.Index = 0
  ) -> TwiFailure? {
    let availableBytes = buffer.count - start

    if let failure = prepareToReceiveBytes(from: registers.lowerBound) {
      return failure
    }

    for i in 0..<registers.count {
      switch Twi.receiveByte(acknowledge: i < registers.count - 1) {
      case .success(let byte):
        if i < availableBytes {
          buffer[start + i] = byte
        }
      case .failure(let failure):
        return failure
      }
    }

    return Twi.sendStopCondition()
  }

  /// Attempts to reads sequential bytes from the register range, passing them to the closure as an ``UnsafeRawBufferPointer``.
  /// Not all TWI registers are necessarily contiguous, but if it's supported by the device, the block of bytes is
  /// copied into the AVR buffer and pointed at by the resulting ``UnsafeRawBufferPointer``. The buffer is only valid
  /// for the duration of the closure's execution.
  ///
  /// - Parameter registers: The range of registers to read from.
  /// - Parameter handler: A closure receiving an `UnsafeRawBufferPointer` for the retrieved block of memory, or `nil` if unable to allocate it.
  @inlinable
  public mutating func readBytes<T>(
    from registers: ClosedRange<TwiSlaveRegisterAddress>,
    into handler: (UnsafeRawBufferPointer) -> T
  ) -> TwiResult<T> {
    let registersCount = registers.count

    guard
      let buffer = UnsafeMutableRawBufferPointer.allocate(
        byteCount: registersCount,
        alignment: MemoryLayout<UInt8>.alignment
      )
    else {
      // out of memory
      fatalError()
    }

    buffer.initializeMemory(as: UInt8.self, repeating: 0)
    defer {
      buffer.deallocate()
    }
    // Get an `UnsafeRawBufferPointer` to the buffer.
    if let failure = readBytes(from: registers, into: buffer) {
      return .failure(failure)
    }

    return .success(handler(UnsafeRawBufferPointer(buffer)))
  }
}

// MARK: - Writing

extension TwiSlaveNode {

  /// Writes a ``RegisterValue`` with a single byte to the specified register.
  ///
  /// - Parameter value: The ``RegisterValue`` to write.
  /// - Parameter register: The register number to write to.
  /// - Throws: If the byte was not sent.
  @inlinable @inline(__always)
  public mutating func writeValue<V: RegisterValue>(
    _ value: V, to register: TwiSlaveRegisterAddress
  ) -> TwiFailure? where V.RegisterType.Magnitude == UInt8 {
    // Send the start condition.
    return prepareToSendBytes(to: register)
      // Send the value.
      ?? Twi.sendByte(UInt8(truncatingIfNeeded: value.registerValue))
      // Send the stop condition.
      ?? Twi.sendStopCondition()
  }

  /// Writes to the specified ``ClosedRange`` of registers with the bytes from the provided value.
  /// The number of registers written to will be the `count` of the `ClosedRange`.
  /// The least significant byte of the ``RegisterValue`` will be written to the highest register in the range.
  /// If the number of registers in the range is greater than the size of the ``RegisterValue``, `0` is written to the lower registers.
  ///
  /// - Parameter value: The value to write.
  /// - Parameter registers: The range of registers to write to.
  /// - Throws: If there was an error writing to the registers.
  @inlinable @inline(__always)
  public mutating func writeValue<V: RegisterValue>(
    _ value: V,
    to registers: ClosedRange<TwiSlaveRegisterAddress>
  ) -> TwiFailure?
  {
    let registersCount = registers.count

    if let failure = prepareToSendBytes(to: registers.lowerBound) {
      return failure
    }

    // The raw value to write.
    let registerValue = value.registerValue

    // Write the bytes.
    for i in stride(from: registersCount - 1, through: 0, by: -1) {
      if let failure = Twi.sendByte(UInt8(truncatingIfNeeded: registerValue >> (8 * i))) {
        return failure
      }
    }

    return Twi.sendStopCondition()
  }

  /// Writes sequential bytes from the `UnsafeRawBufferPointer` to the series of registers starting with `start`.
  /// The lowest register will have the first byte from the buffer starting at written to it.
  ///
  /// - Parameter registers: The range of registers to write to.
  /// - Parameter buffer: The buffer of bytes to write.
  /// - Parameter start: The starting index in the buffer to write from. (defaults to `0`)
  @inlinable @inline(__always)
  public mutating func writeBytes(
    to registers: ClosedRange<TwiSlaveRegisterAddress>,
    from buffer: UnsafeRawBufferPointer,
    startingAt start: Int = 0
  ) -> TwiFailure? {
    let availableBytes = min(buffer.count - start, registers.count)

    if let failure = prepareToSendBytes(to: registers.lowerBound) {
      return failure
    }

    for i in 0..<registers.count {
      let byteToSend = i < availableBytes ? buffer[start + i] : 0
      if let failure = Twi.sendByte(byteToSend) {
        return failure
      }
    }

    return Twi.sendStopCondition()
  }
}