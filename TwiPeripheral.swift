/// A Two Wire Interface peripheral.
public protocol TwiPeripheral {
  associatedtype ActionInterrupt: Interrupt where ActionInterrupt.Source == Self

  /// The Two Wire Interface peripheral's bit rate register.
  @inlinable @inline(__always)
  static var bitRateRegister: UInt8 { get set }

  /// The control register.
  /// This contains several control and status flags. Often, several flags need to be set at once.
  /// For example, a typical sequence for sending a START condition would be:
  ///
  /// ```swift
  /// twi.controlRegister = .init(
  ///  interruptFlag: true,
  ///  startCondition: true,
  ///  enabled: true
  /// )
  /// ```
  ///
  /// By passing in the register value as a parameter, all flags can be set in a single operation.
  // @inlinable @inline(__always)
  // static var controlRegister: TwiControlRegister { get set }

  /// Configures the control register.
  ///
  /// - Parameters:
  ///   - interruptFlag: Whether the interrupt flag should be set.
  ///   - enableAcknowledge: Whether the acknowledge flag should be set.
  ///   - startCondition: Whether the start condition should be sent.
  ///   - stopCondition: Whether the stop condition should be sent.
  ///   - enabled: Whether the peripheral should be enabled.
  @inlinable @inline(__always)
  static func control(
    interruptFlag: Bool,
    enableAcknowledge: Bool,
    startCondition: Bool,
    stopCondition: Bool,
    enabled: Bool
  )

  /// Checks if the TWI peripheral is ready.
  @inlinable @inline(__always)
  static var isReady: Bool { get }

  /// Indicates if the acknowledgement is enabled.
  @inlinable @inline(__always)
  static var acknowledgeEnabled: Bool { get }

  /// Indicates if the start condition is enabled.
  @inlinable @inline(__always)
  static var startConditionEnabled: Bool { get }

  /// Indicates if the stop condition is enabled.
  @inlinable @inline(__always)
  static var stopConditionEnabled: Bool { get }

  /// Indicates if there was a write collision.
  @inlinable @inline(__always)
  static var hadWriteCollision: Bool { get }

  /// Indicates if the TWI peripheral is enabled.
  @inlinable @inline(__always)
  static var enabled: Bool { get }

  /// The Two Wire Interface peripheral's slave address.
  @inlinable @inline(__always)
  static var slaveAddress: TwiSlaveAddress { get set }

  /// Do we respond to the general call address?
  @inlinable @inline(__always)
  static var respondToGeneralCall: Bool { get set }

  /// The prescaler value.
  @inlinable @inline(__always)
  static var prescaler: TwiPrescaler { get set }

  /// The data register.
  @inlinable @inline(__always)
  static var dataRegister: UInt8 { get set }

  /// The status.
  @inlinable @inline(__always)
  static var status: UInt8 { get set }
}

// MARK: - Functions

extension TwiPeripheral {
  /// Configures the control register.
  ///
  /// - Parameters:
  ///   - interruptFlag: Whether the interrupt flag should be set.
  ///   - enableAcknowledge: Whether the acknowledge flag should be set.
  ///   - startCondition: Whether the start condition should be sent.
  ///   - stopCondition: Whether the stop condition should be sent.
  ///   - enabled: Whether the peripheral should be enabled.
  @inlinable @inline(__always)
  public static func control(
    interruptFlag: Bool = false,
    enableAcknowledge: Bool = false,
    startCondition: Bool = false,
    stopCondition: Bool = false,
    enabled: Bool = false
  ) {
    control(
      interruptFlag: interruptFlag,
      enableAcknowledge: enableAcknowledge,
      startCondition: startCondition,
      stopCondition: stopCondition,
      enabled: enabled
    )
  }

  // A set of primitive TWI functions which receive a `HasTwi` source as a parameter and any other required parameters.

  /// Configures the peripheral to operate in master mode.
  ///
  /// - Parameter clockFrequency: The clock frequency to use.
  @inlinable @inline(__always)
  public static func configureAsMaster(clockFrequency: Frequency) {
    let wasEnabled = Self.enabled
    control(enabled: false)
    respondToGeneralCall = false
    bitRateRegister = UInt8((clockFrequency.hertz / 1_000_000) - 16) / 2
    control(enabled: wasEnabled)
  }

  /// Waits for the TWI peripheral to be ready.
  @inlinable @inline(__always)
  public static func waitUntilReady() -> TwiFailure? {
    // TODO: Provide an actual timer/delay function.
    var counter: UInt32 = 0
    while !isReady {
      if counter > 500_000 {
        return .timeout
      }

      // Do an internal loop to avoid checking too often
      for _ in 0..<UInt16(1000) {
        counter += 1
      }
    }
    return nil
  }

  /// Indicates the current action is complete and waits for the interrupt flag to be set.
  /// Once the interrupt flag is set, the status is checked to ensure it matches the expected value.
  ///
  /// - Parameter acknowledge: Whether to send an ACK or NACK. Defaults to NACK.
  /// - Parameter status: The expected status.
  /// - Returns: The current status, if it does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func indicateActionComplete<Status: RawRepresentable>(
    acknowledge: Bool = false, expecting status: Status
  ) -> TwiFailure? where Status.RawValue == UInt8 {
    control(
      interruptFlag: true,
      enableAcknowledge: acknowledge,
      enabled: true
    )

    // Wait for the interrupt flag to be set.
    return waitUntilReady() ?? expectStatus(is: status)
  }

  /// Expects the TWI status to match the provided status, or returns a `TwiFailure.unexpectedStatus`
  ///
  /// - Parameters:
  ///   - status: The expected status.
  /// - Returns: a `TwiFailure.unexpectedStatus` if the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func expectStatus<Status: RawRepresentable>(is status: Status) -> TwiFailure?
  where Status.RawValue == UInt8 {
    let currentStatus = Self.status
    return currentStatus == status.rawValue ? nil : .unexpectedStatus(currentStatus)
  }

  /// Waits until the TWI peripheral is ready, and expects the status to match the provided value.
  ///
  /// - Parameters:
  ///   - status: The expected status.
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func waitUntilStatus<Status: RawRepresentable>(
    is status: Status
  ) -> TwiFailure? where Status.RawValue == UInt8 {
    return waitUntilReady() ?? expectStatus(is: status)
  }

  // MARK: - START/STOP

  /// Sends a START condition.
  ///
  /// - Returns: The result of the operation.
  @inlinable @inline(__always)
  public static func sendStartCondition() -> TwiFailure? {
    control(
      interruptFlag: true,
      startCondition: true,
      enabled: true
    )

    // Wait for the interrupt flag to be set, and expect the status to indicate that the START condition was sent.
    return waitUntilStatus(is: TwiStatus.Master.startConditionTransmitted)
  }

  /// Sends a repeated START condition.
  ///
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendRepeatedStartCondition() -> TwiFailure? {
    control(
      interruptFlag: true,
      startCondition: true,
      enabled: true
    )

    // Expect the status to indicate that the repeated START condition was sent.
    return waitUntilStatus(is: TwiStatus.Master.repeatedStartConditionTransmitted)
  }

  /// Sends a STOP condition.
  ///
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendStopCondition() -> TwiFailure? {
    control(
      interruptFlag: true,
      stopCondition: true,
      enabled: true
    )
    // Wait for the interrupt flag to be set.
    return waitUntilReady()
  }

  // MARK: - Transmitting

  /// Sends a SLA+W to the specified master with the given address.
  ///
  /// - Parameters:
  ///   - address: The address to send.
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendSlaveAddressWrite(for address: TwiSlaveAddress) -> TwiFailure? {
    Self.dataRegister = address.write.registerValue

    return indicateActionComplete(
      expecting: TwiStatus.MasterTransmit.slaveAddressWriteTransmittedAndAckReceived)
  }

  /// Sends a value that can be represented as a single byte.
  ///
  /// - Parameters:
  ///   - value: The ``RawRepresentable`` to send.
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendByte<T: RawRepresentable>(_ value: T) -> TwiFailure?
  where T.RawValue == UInt8 {
    return sendByte(value.rawValue)
  }

  /// Sends a byte.
  ///
  /// - Parameters:
  ///   - value: The byte to send.
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendByte(_ value: UInt8) -> TwiFailure? {
    Self.dataRegister = value

    return indicateActionComplete(
      expecting: TwiStatus.MasterTransmit.dataByteTransmittedAndAckReceived)
  }

  // MARK: - Receiving

  /// Sends a SLA+R to the bus with the given address.
  ///
  /// - Parameters:
  ///   - address: The address to send.
  ///   - twi: The TWI peripheral.
  /// - Returns: A ``TwiFailure`` if waiting times out or the status does not match the expected value, otherwise `nil`.
  @inlinable @inline(__always)
  public static func sendSlaveAddressRead(for address: TwiSlaveAddress) -> TwiFailure? {
    Self.dataRegister = address.read.registerValue

    return indicateActionComplete(
      expecting: TwiStatus.MasterReceive.slaveAddressReadTransmittedAndAckReceived)
  }

  /// Receives a byte.
  ///
  /// - Parameters:
  ///   - acknowledge: Whether to send an ACK or NACK. Defaults to NACK.
  /// - Returns: A ``TwiResult``, with either the received `T` value or a ``TwiFailure``.
  /// - Note: The `.success` result is an optional `T`, since the value may be `nil` if the `RawRepresentable` initialiser returns `nil`.
  @inlinable @inline(__always)
  public static func receiveByte<T: RawRepresentable>(
    acknowledge: Bool = false, as: T.Type = T.self
  ) -> TwiResult<T?> where T.RawValue == UInt8 {
    return receiveByte(acknowledge: acknowledge).map { T(rawValue: $0) }
  }

  /// Receives a byte.
  ///
  /// - Parameters:
  ///   - acknowledge: Whether to send an ACK or NACK. Defaults to NACK.
  /// - Returns: The received byte.
  @inlinable @inline(__always)
  public static func receiveByte(acknowledge: Bool = false) -> TwiResult<UInt8> {
    if let failure = indicateActionComplete(
      acknowledge: acknowledge, expecting: TwiStatus.MasterReceive.dataByteReceivedAndAckReturned)
    {
      return .failure(failure)
    }
    return .success(Self.dataRegister)
  }
}
