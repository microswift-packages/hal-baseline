/// A protocol indicating that a type has global interrupt support.
public protocol HasGlobalInterruptSupport {
  @inlinable @inline(__always)
  static var globalInterruptsEnabled: Bool { get set }
}