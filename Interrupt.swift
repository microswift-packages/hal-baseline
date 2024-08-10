public typealias InterruptHandler = @convention(c) () -> Void

/// An abstraction of an interrupt. It provides a common interface for interrupts, with functions for enabling and
/// disabling the interrupt, and checking if it has been triggered.
public protocol Interrupt {
  /// The source of the interrupt.
  associatedtype Source

  /// Is the interrupt enabled?
  @inlinable @inline(__always)
  static var enabled: Bool { get set }
  
  /// If `true`, the interrupt has been triggered, but the handler has not been called yet.
  @inlinable @inline(never)
  static var triggered: Bool { get }

  /// Clears the interrupt flag.
  @inlinable @inline(__always)
  static func clear()

  /// A handler that is called when the interrupt is triggered.
  ///
  /// - Parameters:
  ///   - enabled: If `true`, the interrupt is enabled. (default: true)
  ///   - handler: The closure to call when the interrupt is triggered.
  @inlinable @inline(__always)
  static func onTrigger(enabled: Bool, _ handler: @escaping InterruptHandler)
}

// Allow calling the `onTrigger` method when "calling" the interrupt instance itself.
extension Interrupt {
  /// A handler that is called when the interrupt is triggered. The interrupt
  /// will be `enabled` after the handler has been set.
  ///
  /// - Parameters:
  ///   - handler: The closure to call when the interrupt is triggered.
  @inlinable @inline(__always)
  public static func onTrigger(_ handler: @escaping InterruptHandler) {
    Self.onTrigger(enabled: true, handler)
  }
}