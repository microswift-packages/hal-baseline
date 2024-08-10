/// Represents the result of a TWI operation.
public enum TwiResult<Value> {
  /// The operation was successful.
  case success(Value)

  /// Failure.
  case failure(TwiFailure)

  /// Checks if the result is a success.
  ///
  /// - Returns: `true` if the result is a success, otherwise `false`.
  @inlinable @inline(__always)
  public var isSuccess: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }

  /// Checks if the result is a failure.
  ///
  /// - Returns: `true` if the result is a failure, otherwise `false`.
  @inlinable @inline(__always)
  public var isFailure: Bool {
    switch self {
    case .success: return false
    case .failure: return true
    }
  }

  /// Returns the value if the result is a success, otherwise `nil`.
  @inlinable @inline(__always)
  public var value: Value? {
    switch self {
    case .success(let value): return value
    default: return nil
    }
  }

  /// Returns the failure if the result is a failure, otherwise `nil`.
  @inlinable @inline(__always)
  public var failure: TwiFailure? {
    switch self {
    case .failure(let failure): return failure
    default: return nil
    }
  }

  /// Maps the value of the result to a new type, otherwise resturns the failure unchanged.
  ///
  /// - Parameters:
  ///   - transform: The transform to apply to the value.
  /// - Returns: The transformed result.
  @inlinable @inline(__always)
  public func map<T>(_ transform: (Value) -> T) -> TwiResult<T> {
    switch self {
    case .success(let value): return .success(transform(value))
    case .failure(let failure): return .failure(failure)
    }
  }
}

extension TwiResult where Value == Void {
  /// Creates a success result.
  @inlinable @inline(__always)
  public static var success: TwiResult {
    return .success(())
  }
}

extension TwiResult: Equatable where Value: Equatable {}
