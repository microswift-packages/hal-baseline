/// The state of a pullup resistor.
public enum PullupState {
  case enabled
  case disabled
}

extension PullupState: Equatable, Hashable {
  @inlinable @inline(__always)
  public static func == (lhs: PullupState, rhs: PullupState) -> Bool {
    switch (lhs, rhs) {
    case (.enabled, .enabled): return true
    case (.disabled, .disabled): return true
    default: return false
    }
  }
}

extension PullupState: CustomStaticStringConvertible {
  @inlinable @inline(__always)
  public var staticDescription: StaticString {
    switch self {
    case .enabled: return "ENABLED"
    case .disabled: return "DISABLED"
    }
  }
}
