/// A type that provides basic 8-bit synchronous serial communication functionality, using a UART peripheral.
///
/// To attach to a specific UART peripheral, use the ``AsyncSerial/init(with:clockSpeed:)`` initializer. For example:
///
/// ```swift
/// var serial = AsyncSerial(with: atmega328p.uart0, clockSpeed: .at16MHz
/// ```
///
/// To actually connect and configure the UART peripheral, call the ``AsyncSerial/begin(baudRate:characterSize:numberOfStopBits:)`` method. For example:
///
/// ```swift
/// serial.begin(baudRate: .at57_6kbps)
/// ```
///
/// ## Writing
///
/// To send raw bytes, there are several `write` methods. For example:
///
/// ```swift
/// serial.writeByte(0x01)
/// serial.writeBytes([0x01, 0x02, 0x03])
/// serial.writeNineBits(0x1F) // used when `characterSize` is `.nine`
/// ```
///
/// ## Reading
/// 
/// To read raw bytes, there are several `read` methods. For example:
///
/// ```swift
/// let byte = serial.readByte()
/// let nineBits: UInt16 = serial.readNineBits() // used when `characterSize` is `.nine`
/// ```
/// 
/// For longer data, you `receive` data into a buffer. For example:
///
/// ```swift
/// var buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 16, alignment: 1)
/// defer { buffer.deallocate() }
/// serial.receive(into: buffer) // reads up to 16 bytes
/// ```
/// 
/// You can also specify a start and count:
///
/// ```swift
/// var buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 16, alignment: 1)
/// defer { buffer.deallocate() }
/// serial.receive(into: buffer, start: 4, count: 8) // reads 8 bytes into the middle of the buffer
/// ```
///
/// You can also specify a particular type to receive into the buffer, via `UnsafeMutableBufferPointer`. For example:
/// 
/// ```swift
/// var buffer = UnsafeMutableBufferPointer<UInt16>.allocate(capacity: 8)
/// defer { buffer.deallocate() }
/// serial.receive(into: buffer) // reads 8 16-bit values into the buffer
/// ```
///
/// You can also receive until a particular terminator byte is received. For example:
///
/// ```swift
/// var buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 16, alignment: 1)
/// defer { buffer.deallocate() }
/// serial.receive(into: buffer, terminator: 0x00) // reads up to 16 bytes, or until a 0x00 is received
/// ```
///
/// If the buffer is not large enough to hold all the received data, it will return once the buffer is full.
/// You can check if it was truncated by checking the return value of the `receive` method. For example:
///
/// ```swift
/// let (count, found) = serial.receive(into: buffer, terminator: 0x00)
/// if found {
///   // the terminator was found
/// } else {
///   // the terminator was not found
/// }
/// ```
/// 
/// ## Printing
/// 
/// To print values as text, you can create a ``Printer`` via the ``AsyncSerial/printer`` property. For example:
///
/// ```swift
/// let out = serial.printer
/// out.print("Hello, world!")
/// ```
///
/// See ``Printer`` for more information.
///
/// ### Logging
///
/// The ``AsyncSerial`` type also provides a ``Logger`` via the ``AsyncSerial/logger`` property.
///
/// Loggers differ from Printers in a couple of ways.
///
/// First, they are configured with a ``Logger/level``. This allows you to specify a minimum level of logging that will be printed.
/// For example, if you set the level to `.warn`, then only `.warn`, `.error`, and `.fatal` messages will be printed.
/// Secondly, they output the logger name and message level before the message.
/// 
/// For example:
///
/// ```swift
/// let log = serial.logger(named: "MyLogger", level: .warn)
/// log?.debug("Hello, world!") // this will not be printed
/// log?.warn("Goodbye, world!") // this will be printed
/// ```
///
/// See ``Logger`` for more information.
public struct AsyncSerial<Source: HasUart> where Source.Uart.DataType == UInt8 {
  /// The type of the UART peripheral.
  public typealias Uart = Source.Uart

  /// The clock speed we are running at.
  @usableFromInline
  let clockSpeed: Frequency

  /// Creates a new serial communication interface.
  ///
  /// - Parameter source: A type that has a default UART peripheral.
  /// - Parameter clockSpeed: The clock speed of the UART peripheral.
  @inlinable @inline(__always)
  public init(clockSpeed: Frequency) {
    self.clockSpeed = clockSpeed
  }
}

extension AsyncSerial where Source: HasClockSpeed {
  /// Creates a new serial communication interface with a value that has a default UART peripheral and clock speed.
  ///
  /// - Parameter source: A type that has a default UART peripheral and clock speed.
  @inlinable @inline(__always)
  public init() {
    self.init(clockSpeed: Source.clockSpeed)
  }
}

extension AsyncSerial {
  /// Configures the UART peripheral and enables transmission and reception.
  ///
  /// - Parameters:
  ///   - baudRate: The baud rate to use.
  ///   - characterSize: The number of data bits to use. (default: `.eight`)
  ///   - numberOfStopBits: The number of stop bits to use. (default: `.one`)
  @inlinable @inline(__always)
  public func begin(
    baudRate: UartBaudRate,
    asyncDoubleSpeed: Bool = false,
    numberOfDataBits: UartNumberOfDataBits = .eight,
    numberOfStopBits: UartNumberOfStopBits = .one
  ) {
    Uart.configure(mode: .asynchronous(clockSpeed: clockSpeed, baudRate: baudRate, doubleSpeed: asyncDoubleSpeed))
    Uart.numberOfDataBits = numberOfDataBits
    Uart.numberOfStopBits = numberOfStopBits

    Uart.transmitterEnable = true
    Uart.receiverEnable = true
  }

  /// Disables transmission and reception.
  @inlinable @inline(__always)
  public func end() {
    Uart.transmitterEnable = false
    Uart.receiverEnable = false
  }
}

// MARK: - Writing

extension AsyncSerial {
  /// Writes a single byte to the UART peripheral.
  ///
  /// - Parameter byte: The byte to write.
  @inlinable @inline(__always)
  public func writeByte(_ byte: UInt8) {
    while !Uart.dataRegisterEmpty {}
    Uart.data = Uart.DataRegisterType(registerValue: byte)
  }

  /// Writes a 9-bit value to the UART peripheral.
  ///
  /// - Parameter value: The value to write.
  @inlinable @inline(__always)
  public func writeNineBits(_ value: UInt16) {
    while !Uart.dataRegisterEmpty {}
    Uart.transmitDataBit8 = value & 0x100 != 0
    Uart.data = Uart.DataRegisterType(registerValue: UInt8(value) & 0xFF)
  }


  /// Writes a sequence of bytes to the UART peripheral.
  ///
  /// - Parameter bytes: The bytes to write.
  @inlinable @inline(__always)
  public func writeBytes<S: Sequence>(_ bytes: S) where S.Element == UInt8 {
    for byte in bytes {
      self.writeByte(byte)
    }
  }
}

// MARK: - Reading

extension AsyncSerial {
  /// Reads a single byte from the UART peripheral.
  ///
  /// - Returns: The byte read.
  @inlinable @inline(__always)
  public func readByte() -> Uart.DataRegisterType {
    while !Uart.receiveComplete {}
    return Uart.data
  }

  /// Reads a 9-bit value from the UART peripheral.
  ///
  /// - Returns: The value read.
  @inlinable @inline(__always)
  public func readNineBits() -> UInt16 {
    while !Uart.receiveComplete {}
    let bit8: UInt16 = Uart.receiveDataBit8 ? 0x100 : 0
    let data: UInt16 = UInt16(Uart.data.registerValue)
    return bit8 | data
  }
}

// MARK: - Receiving

extension AsyncSerial {
  /// Receives a specified number of bytes from the UART peripheral into an `UnsafeMutableRawBufferPointer`.
  /// The content is untyped, and is accessible as raw `UInt8` values.
  ///
  /// - Parameter buffer: The buffer to receive the bytes into.
  /// - Parameter start: The index of the first byte to receive. Defaults to `0`.
  /// - Parameter count: The number of bytes to receive. Defaults to the remaining size of the buffer after the `start`.
  /// - Returns: The number of bytes received.
  ///
  /// - Note: The caller is responsible for deallocating the buffer.
  @inlinable @inline(__always)
  public func receive(into buffer: UnsafeMutableRawBufferPointer, start: Int = 0, count: Int? = nil) -> Int {
    let start = min(start, buffer.count)
    let maxCount = buffer.count - start
    let count = min(count ?? maxCount, maxCount)
    for i in 0..<count {
      buffer[i] = self.readByte().registerValue
    }
    return count
  }

  /// Receives a specified number of type values from the UART peripheral into an `UnsafeMutableBufferPointer`.
  ///
  /// - Parameter buffer: The buffer to receive the values into.
  /// - Parameter start: The index of the first value to receive. Defaults to `0`.
  /// - Parameter count: The number of values to receive. Defaults to the remaining size of the buffer after the `start`.
  /// - Parameter as: The type of the values to receive. Defaults to `T.self`.
  /// - Returns: The number of values received.
  ///
  /// - Note: The caller is responsible for deallocating the buffer.
  @inlinable @inline(__always)
  public func receive<T>(into buffer: UnsafeMutableBufferPointer<T>, start: Int = 0, count: Int? = nil, as: T.Type = T.self) -> Int {
    // convert the buffer to a raw buffer
    let rawBuffer = UnsafeMutableRawBufferPointer(buffer)
    // receive the raw bytes
    let byteCount = self.receive(into: rawBuffer, start: start * MemoryLayout<T>.stride, count: count.map { $0 * MemoryLayout<T>.stride })
    // return the number of values received
    return byteCount / MemoryLayout<T>.stride
  }

  /// Receives a series of bytes from the UART peripheral into an `UnsafeMutableRawBufferPointer`,
  /// terminated by a specific byte value or the end of the buffer.
  /// The content is untyped, and is accessible as raw `UInt8` values.
  ///
  /// - Parameter buffer: The buffer to receive the bytes into.
  /// - Parameter terminator: The byte value to terminate the receive operation on.
  /// - Parameter start: The index of the first byte to receive. Defaults to `0`.
  ///
  /// - Returns: a tupple containing the number of bytes received, and a boolean indicating whether the terminator was found.
  ///
  /// - Note: The caller is responsible for deallocating the buffer.
  @inlinable @inline(__always)
  public func receive(into buffer: UnsafeMutableRawBufferPointer, until terminator: UInt8, start: Int = 0) -> (count: Int, found: Bool) {
    let start = min(start, buffer.count)
    for i in start..<buffer.count {
      let byte = self.readByte().registerValue
      buffer[i] = byte
      if byte == terminator {
        return (i + 1, true)
      }
    }
    return (buffer.count-start, false)
  }

  /// Receives a series of bytes from the UART peripheral into an `UnsafeMutableRawBufferPointer`,
  /// terminated by a specific byte sequence in the provided `UnsafeRawBufferPointer` or the end of the buffer.
  /// The content is untyped, and is accessible as raw `UInt8` values.
  ///
  /// - Parameter buffer: The buffer to receive the bytes into.
  /// - Parameter terminator: The byte value to terminate the receive operation on.
  /// - Parameter start: The index of the first byte to receive. Defaults to `0`.
  ///
  /// - Returns: a tupple containing the number of bytes received, and a boolean indicating whether the terminator was found.
  ///
  /// - Note: The caller is responsible for deallocating the buffer.
  @inlinable @inline(__always)
  public func receive(into buffer: UnsafeMutableRawBufferPointer, until terminator: UnsafeRawBufferPointer, start: Int = 0) -> (count: Int, found: Bool) {
    let start = min(start, buffer.count)

    for i in start..<buffer.count {
      let byte = self.readByte().registerValue
      buffer[i] = byte
      if buffer.ends(with: terminator) {
        return (i + 1, true)
      }
    }
    return (buffer.count-start, false)
  }


  /// Receives a series of type values from the UART peripheral into an `UnsafeMutableBufferPointer`,
  /// terminated by a specific value or the end of the buffer.
  ///
  /// - Parameter buffer: The buffer to receive the values into.
  /// - Parameter terminator: The value to terminate the receive operation on.
  /// - Parameter start: The index of the first value to receive. Defaults to `0`.
  /// - Parameter as: The type of the values to receive. Defaults to `T.self`.
  ///
  /// - Returns: a tupple containing the number of values received, and a boolean indicating whether the terminator was found.
  ///
  /// - Note: The caller is responsible for deallocating the buffer.
  @inlinable @inline(__always)
  public func receive<T>(into buffer: UnsafeMutableBufferPointer<T>, until terminator: T, start: Int = 0, as: T.Type = T.self) -> (count: Int, found: Bool) {
    // convert the buffer to a raw buffer
    let rawBuffer = UnsafeMutableRawBufferPointer(buffer)
    // convert the terminator to an UnsafeRawBufferPointer
    var terminator = terminator
    let terminatorBuffer = UnsafeRawBufferPointer(start: &terminator, count: MemoryLayout<T>.stride)
    
    // receive the raw bytes
    let (byteCount, found) = self.receive(into: rawBuffer, until: terminatorBuffer, start: start * MemoryLayout<T>.stride)
    // return the number of values received
    return (byteCount / MemoryLayout<T>.stride, found)
  }
}
