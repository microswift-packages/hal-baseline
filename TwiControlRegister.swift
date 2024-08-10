/// An implementation of a typical TWCR register on a TWI peripheral.
public struct TwiControlRegister: MutableRegisterValue {
  
  /// The raw register value.
  public var registerValue: UInt8

  /// Initializes the register with its raw value.
  @inlinable @inline(__always)
  public init(registerValue: UInt8) {
    self.registerValue = registerValue
  }

  /// The interrupt flag.
  @inlinable @inline(__always)
  public var interruptFlag: Bool {
    get { hasBit(at: 7) }
    set { setBit(at: 7, to: newValue) }
  }

  /// The Two Wire Interface peripheral's bit rate register.
  @inlinable @inline(__always)
  public var enableAcknowledge: Bool {
    get { hasBit(at: 6) }
    set { setBit(at: 6, to: newValue) }
  }

  /// The Two Wire Interface start condition.
  @inlinable @inline(__always)
  public var startCondition: Bool {
    get { hasBit(at: 5) }
    set { setBit(at: 5, to: newValue) }
  }

  /// The Two Wire Interface stop condition.
  @inlinable @inline(__always)
  public var stopCondition: Bool {
    get { hasBit(at: 4) }
    set { setBit(at: 4, to: newValue) }
  }

  /// Was there a write collision?
  /// This will be `true` if the TWI data register was written to while the TWI interrupt flag was low.
  /// It can be cleared by writing to the TWI data register while the TWI interrupt flag is high.
  @inlinable @inline(__always)
  public var hadWriteCollision: Bool {
    get { hasBit(at: 3) }
    set { setBit(at: 3, to: newValue) }
  }

  /// The Two Wire Interface enable bit.
  @inlinable @inline(__always)
  public var enabled: Bool {
    get { hasBit(at: 2) }
    set { setBit(at: 2, to: newValue) }
  }

  /// Initialize a `TwiControlRegister` instance with the specified flag states.
  ///
  /// - Parameters:
  ///   - interruptFlag: The interrupt flag.
  ///   - enableAcknowledge: The enable acknowledge flag.
  ///   - startCondition: The start condition flag.
  ///   - stopCondition: The stop condition flag.
  ///   - hadWriteCollision: The write collision flag.
  ///   - enabled: The enable flag.
  @inlinable @inline(__always)
  public init(
    interruptFlag: Bool = false,
    enableAcknowledge: Bool = false,
    startCondition: Bool = false,
    stopCondition: Bool = false,
    hadWriteCollision: Bool = false,
    enabled: Bool = false
  ) {
    self.registerValue = 0
    self.interruptFlag = interruptFlag
    self.enableAcknowledge = enableAcknowledge
    self.startCondition = startCondition
    self.stopCondition = stopCondition
    self.hadWriteCollision = hadWriteCollision
    self.enabled = enabled
  }
}
