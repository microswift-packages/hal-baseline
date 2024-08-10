/// A protocol for Watchdog Timer timeout fields.
public protocol WatchdogTimeoutField {
  /// The bit-width of the timeout select field.
  @inlinable @inline(__always)
  static var bitWidth: UInt8 { get }

  /// The mask for the timeout select field, with the least significant bit at the start of the mask.
  @inlinable @inline(__always)
  static var bitMask: UInt8 { get }

  /// The bitfield value of the timeout select field. It will be masked to the bit width of the field.
  @inlinable @inline(__always)
  var bitfieldValue: UInt8 { get }

  /// Initializes a prescale select field from a bitfield value. It will be masked to the bit width of the field.
  @inlinable @inline(__always)
  init(bitfieldValue: UInt8)

  /// Around 16ms
  @inlinable @inline(__always)
  static var around16ms: Self { get }

  /// Around 32ms
  @inlinable @inline(__always)
  static var around32ms: Self { get }

  /// Around 64ms
  @inlinable @inline(__always)
  static var around64ms: Self { get }

  /// Around 125ms
  @inlinable @inline(__always)
  static var around125ms: Self { get }

  /// Around 250ms
  @inlinable @inline(__always)
  static var around250ms: Self { get }

  /// Around 500ms
  @inlinable @inline(__always)
  static var around500ms: Self { get }

  /// Around 1s
  @inlinable @inline(__always)
  static var around1s: Self { get }

  /// Around 2s
  @inlinable @inline(__always)
  static var around2s: Self { get }
}
