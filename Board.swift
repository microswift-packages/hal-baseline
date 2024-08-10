/// Indicates a type is a (development) board containing a microcontroller.
public protocol Board {
  /// The type of microcontroller packaging used on the board.
  associatedtype Packaging: HAL.Packaging

  /// The type of microcontroller used on the board.
  typealias Chip = Packaging.Chip

  /// The human-readable name of the board.
  static var name: StaticString { get }

  /// The vendor ID
  static var vendorId: UInt16 { get }

  /// The product ID
  static var productId: UInt16 { get }

  /// The clock speed of the microcontroller.
  static var clockSpeed: Frequency { get }
}
