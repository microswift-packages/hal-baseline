/// This represents a pin that is monitored by a ``PinChangeInterrupt``.
/// Each ``PinChangeInterrupt`` has a single handler function which can be triggered
/// by a change in any of the pins it is monitoring.
public protocol MonitorPin {
  /// The ``PinChangeInterrupt`` this pin is linked with.
  associatedtype Interrupt: PinChangeInterrupt

  /// The pin number within the interrupt's set of pins (between `0`-`7`).
  @inlinable @inline(__always)
  static var pinNumber: UInt8 { get }

  /// Configures the pin to trigger the interrupt when it changes.
  ///
  /// - Parameters:
  ///   - enabled: Whether the pin should trigger the interrupt when it changes.
  /// - Note: This does not enable or configure the interrupt itself. That must be done separately.
  @inlinable @inline(__always)
  static func configure(enabled: Bool)

  /// Whether the pin is configured to trigger the interrupt when it changes.
  @inlinable @inline(__always)
  static var enabled: Bool { get }
}

extension MonitorPin {
  /// Configures the pin to trigger the interrupt when it changes. It also enables the
  /// interrupt and sets the handler.
  ///
  /// - Parameters:
  ///   - enabled: Whether the pin should trigger the interrupt when it changes.
  ///   - handler: The handler to call when the interrupt is triggered.
  public static func configure(enabled: Bool, _ handler: @escaping InterruptHandler) {
    Self.configure(enabled: enabled)
    Interrupt.onTrigger(handler)
  }
}
