// TODO: See if there are any useful abstractions we can make here.

/// Indicates a type is a microcontroller.
public protocol Chip {
  /// The human-readable name of the microcontroller.
  static var name: StaticString { get }
}