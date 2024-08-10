// Adds Printer support to `AsyncSerial`.

extension Printer {
  /// Constructs a `Printer` that writes to the specified UART peripheral.
  ///
  /// - Parameter serial: The `AsyncSerial` to write to.
  @inlinable @inline(__always)
  public init<Source: HasUart>(with serial: AsyncSerial<Source>) where Source.Uart.DataType == UInt8 {
    self.init { serial.writeByte($0) }
  }
}

extension AsyncSerial {
  /// Constructs a `Printer` that writes to the UART peripheral.
  ///
  /// - Parameter uart: The UART peripheral to write to.
  @inlinable @inline(__always)
  public var printer: Printer {
    return Printer { self.writeByte($0) }
  }
}
