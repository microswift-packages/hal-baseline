/// Represents the basic configuration of a UART peripheral. Other values are set using specific acessors in ``UartPeripheral``.
public enum UartModeConfig {
  /// Asynchronous mode, with a given clock speed and baud rate, and the option to double the speed.
  case asynchronous(clockSpeed: Frequency, baudRate: UartBaudRate, doubleSpeed: Bool)
  /// Synchronous mode, with a given clock speed and baud rate.
  case synchronous(clockSpeed: Frequency, baudRate: UartBaudRate)

  /// The mode of the UART.
  @inlinable @inline(__always)
  public var mode: UartModeSelect {
    switch self {
    case .asynchronous:
      return .asynchronous
    case .synchronous:
      return .synchronous
    }
  }

  /// The clock speed of the UART, in hertz.
  @inlinable @inline(__always)
  public var clockSpeed: Frequency {
    switch self {
    case .asynchronous(clockSpeed: let speed, baudRate: _, doubleSpeed: _):
      return speed
    case .synchronous(clockSpeed: let speed, baudRate: _):
      return speed
    }
  }

  /// The baud rate of the UART, in bits per second.
  @inlinable @inline(__always)
  public var baudRate: UartBaudRate {
    switch self {
    case .asynchronous(clockSpeed: _, baudRate: let rate, doubleSpeed: _):
      return rate
    case .synchronous(clockSpeed: _, baudRate: let rate):
      return rate
    }
  }

  /// Whether we are in double-speed asynchronous mode.
  @inlinable @inline(__always)
  public var doubleSpeed: Bool {
    switch self {
    case .asynchronous(clockSpeed: _, baudRate: _, doubleSpeed: let double):
      return double
    case .synchronous(clockSpeed: _, baudRate: _):
      return false
    }
  }

  /// Calculates the UBRRn register value given the frequency and transmission speed.
  @inlinable @inline(__always)
  public var baudRateRegister: UInt16 {
    let clockSpeed: Frequency
    let baudRate: UartBaudRate
    let asyncDoubleSpeed: Bool

    switch self {
    case .asynchronous(clockSpeed: let speed, baudRate: let rate, doubleSpeed: let double):
      clockSpeed = speed
      baudRate = rate
      asyncDoubleSpeed = double
    case .synchronous(clockSpeed: let speed, baudRate: let rate):
      clockSpeed = speed
      baudRate = rate
      asyncDoubleSpeed = false
    }

    let divisor: UInt32 = asyncDoubleSpeed ? 8 : 16
    let quotient = (clockSpeed.hertz / baudRate.bitsPerSecond) / divisor
    return UInt16(quotient - 1)
  }
}
