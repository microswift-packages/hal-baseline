/// Represents a failure during a TWI operation.
public enum TwiFailure: Equatable {
  /// Received an unexpected status.
  case unexpectedStatus(UInt8)

  /// The operation timed out.
  case timeout
}

// MARK: - Formatters

extension Formatter where Value == TwiFailure {
  /// Creates a new formatter for `TwiFailure`s.
  @inlinable @inline(__always)
  public static var twiFailure: Formatter<Value> {
    Formatter<Value> { value, printer in
      printer.print("TWI Failure: ")
      switch value {
      case .unexpectedStatus(let status):
        printer.print("Unexpected status: 0x")
        printer.print(status, as: .unsignedInteger(radix: 16))
      case .timeout:
        printer.print("Timeout")
      }
    }
  }
}

extension TwiFailure: DefaultFormatterProvider {
  /// The default formatter for `TwiFailure`.
  @inlinable @inline(__always)
  public static var defaultFormatter: Formatter<Self> {
    Formatter<Self>.twiFailure
  }
}
