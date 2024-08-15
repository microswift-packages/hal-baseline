//===----------------------------------------------------------------------===//
// UART Serial Communications
//===----------------------------------------------------------------------===//

public protocol UartPeripheral {
  // This will probably(?) be `UInt8`, but is useful for preventing the protocol
  // from ever accidentally being used as an existential type
  associatedtype DataRegisterType: MutableRegisterValue

  /// The data register type of the UART peripheral. This may be different to the ``DataRegister`` type
  typealias DataType = DataRegisterType.RegisterType

  /// Configures the UART peripheral with the given mode.
  /// It includes the following:
  /// - `clockSpeed`: The clock speed of the UART peripheral.
  /// - `baudRate`: The baud rate of the UART peripheral.
  /// - `doubleSpeed`: If the UART peripheral is in asynchronous mode, this will double the speed of the UART peripheral.
  ///
  /// Once called, it will have set the following:
  /// - `UMSELn1:0`: Set to either `asynchronous` or `synchronous` mode.
  /// - `UBRRnL`: The lower 8 bits of the baud rate divisor.
  /// - `UBRRnH`: The upper 4 bits of the baud rate divisor.
  /// - `U2Xn`: To either 0 or 1, depending on if `doubleSpeed` is true or false.
  ///
  /// - Parameters:
  ///   - config: The ``ModeConfig`` of operation of the `UartPeripheral`.
  @inlinable @inline(__always)
  static func configure(mode config: UartModeConfig)

  /// The actual data. (UDRn)
  @inlinable @inline(__always)
  static var data: DataRegisterType { get set }

  /// Indicates if the UART port is currently transmitting data. (RXCn)
  /// This flag bit is set when there are unread data in the receive buffer and cleared when
  /// the receive buffer is empty (i.e., does not contain any unread data). If the receiver is
  /// disabled, the receive buffer will be flushed and consequently the RXCn bit will become zero.
  /// The RXCn flag can be used to generate a receive complete interrupt (see description of the
  /// RXCIEn bit).
  @inlinable @inline(never)
  static var receiveComplete: Bool { get }

  /// Indicates if the UART port is currently receiving data. (TXCn)
  /// This flag bit is set when the entire frame in the transmit shift register has been shifted
  /// out and there are no new data currently present in the transmit buffer (UDRn). The TXCn flag
  /// bit is automatically cleared when a transmit complete interrupt is executed, or it can be
  /// cleared by writing a one to its bit location. The TXCn flag can generate a transmit complete
  /// interrupt (see description of the TXCIEn bit).
  @inlinable @inline(never)
  static var transmitComplete: Bool { get }

  /// Indicates if the UART port is ready to transmit data. (UDREn)
  /// This flag bit is set when there are unread data in the receive buffer and
  /// cleared when the receive buffer is empty (i.e., does not contain any unread data).
  /// If the receiver is disabled, the receive buffer will be flushed and consequently
  /// the RXCn bit will become zero. The RXCn flag can be used to generate a receive
  /// complete interrupt (see description of the RXCIEn bit).
  @inlinable @inline(never)
  static var dataRegisterEmpty: Bool { get }

  /// Frame Error. (FEn)
  /// This bit is set if the next character in the receive buffer had a frame error when received.
  /// I.e., when the first stop bit of the next character in the receive buffer is zero.
  /// This bit is valid until the receive buffer (UDRn) is read. The FEn bit is zero when the stop
  /// bit of received data is one. Always set this bit to zero when writing to UCSRnA.
  @inlinable @inline(__always)
  static var frameError: Bool { get }

  /// Data OverRun. (DORn)
  /// This bit is set if a data overrun condition is detected. A data overrun occurs when the receive buffer is full (two characters),
  /// it is a new character waiting in the receive shift register, and a new start bit is detected.
  /// This bit is valid until the receive buffer (UDRn) is read. Always set this bit to zero when writing to UCSRnA.
  @inlinable @inline(__always)
  static var dataOverRun: Bool { get }

  /// Parity Error. (UPEn)
  /// This bit is set if the next character in the receive buffer had a parity error when received and the parity checking was enabled at that point (UPMn1 = 1).
  /// This bit is valid until the receive buffer (UDRn) is read. Always set this bit to zero when writing to UCSRnA.
  @inlinable @inline(__always)
  static var parityError: Bool { get }

  /// Double the USART Transmission Speed. (U2Xn)
  /// This bit only has effect for the asynchronous operation. Write this bit to zero when using synchronous operation.
  /// Writing this bit to one will reduce the divisor of the baud rate divider from 16 to 8 effectively doubling the transfer
  /// rate for asynchronous communication.
  @inlinable @inline(__always)
  static var asyncDoubleSpeed: Bool { get }

  /// Multi-processor Communication Mode. (MPCMn)
  /// This bit enables the multi-processor communication mode. When the MPCMn bit is written to one, all the incoming frames
  /// received by the USART receiver that do not contain address information will be ignored.
  /// The transmitter is unaffected by the MPCMn setting. For more detailed information see Section 19.9 “Multi-processor Communication Mode” on page 158.
  @inlinable @inline(__always)
  static var multiProcessorCommunicationMode: Bool { get set }

  /// Receiver Enable (RXEN)
  /// This bit enables the receiver. When the receiver is enabled, and the RXDn pin is high, the USART will start
  /// sampling the incoming data on the RXDn pin at the configured USART baud rate. The first falling edge of RXDn will
  /// indicate the start of a new frame. The receiver will sample the incoming data on the following edges of the RXDn
  /// pin. The receiver will store the incoming data in the receive buffer (UDRn). If the receiver is disabled, the
  /// receive buffer will be flushed and consequently the RXCn bit will become zero.
  @inlinable @inline(__always)
  static var receiverEnable: Bool { get set }

  /// Transmitter Enable (TXEN)
  /// This bit enables the transmitter. When the transmitter is enabled, and the TXDn pin is configured as an output,
  /// the USART will start driving the TXDn pin if there is new data in the transmit buffer (UDRn). The first falling
  /// edge of TXDn will indicate the start of a new frame. The transmitter will drive the TXDn pin according to the
  /// following bits in the transmit buffer (UDRn). If the transmitter is disabled, the transmitter will continue to
  /// drive the TXDn pin as long as the TXDn pin is configured as an output. The transmitter will be disabled when
  /// the transmit buffer (UDRn) is empty.
  @inlinable @inline(__always)
  static var transmitterEnable: Bool { get set }

  /// Character Size (UCSZn2:0)
  /// The UCSZn1:0 bits combined with the UCSZn2 bit in UCSRnB sets the number of data bits (character size) in a frame the receiver and transmitter use.
  /// UCSZn2 | UCSZn1 | UCSZn0 | Character Size
  /// 0 | 0 | 0 | 5-bit
  /// 0 | 0 | 1 | 6-bit
  /// 0 | 1 | 0 | 7-bit
  /// 0 | 1 | 1 | 8-bit
  /// 1 | 0 | 0 | Reserved
  /// 1 | 0 | 1 | Reserved
  /// 1 | 1 | 0 | Reserved
  /// 1 | 1 | 1 | 9-bit
  @inlinable @inline(__always)
  static var numberOfDataBits: UartNumberOfDataBits { get set }

  /// Receive Data Bit 8 (RXB8)
  /// The ninth data bit of the received character when operating with serial frames with nine data bits. Must be read before reading the low bits from UDRn.
  @inlinable @inline(__always)
  static var receiveDataBit8: Bool { get }

  /// Transmit Data Bit 8 (TXB8)
  /// The ninth data bit of the character to be transmitted when operating with serial frames with nine data bits. Must be written before writing the low bits to UDRn.
  @inlinable @inline(__always)
  static var transmitDataBit8: Bool { get set }

  /// USART Mode Select (UMSELn1:0)
  /// These bits select the mode of operation of the USARTn.
  @inlinable @inline(__always)
  static var mode: UartModeSelect { get }

  /// Parity Mode (UPMn1:0)
  /// These bits enable and set type of parity generation and check.
  /// If enabled, the transmitter will automatically generate and send the parity of the transmitted data bits within each frame.
  /// The receiver will generate a parity value for the incoming data and compare it to the UPMn setting.
  /// If a mismatch is detected, the UPEn flag in UCSRnA will be set.
  @inlinable @inline(__always)
  static var parityMode: UartParityMode { get set }

  /// Stop Bit Select (USBSn)
  /// This bit selects the number of stop bits to be inserted by the transmitter.
  /// The receiver ignores this setting.
  @inlinable @inline(__always)
  static var numberOfStopBits: UartNumberOfStopBits { get set }

  /// Clock Polarity (UCPOLn)
  /// This bit is used for synchronous mode only.
  /// Write this bit to zero when asynchronous mode is used.
  /// The UCPOLn bit sets the relationship between data output change and data input
  /// sample, and the synchronous clock (XCKn).
  @inlinable @inline(__always)
  static var clockPolarity: UartClockPolarity { get set }
}
