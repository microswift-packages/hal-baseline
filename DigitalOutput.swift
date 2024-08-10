/// Represents a digital output pin.
public protocol DigitalOutput {
  /// Configures the pin as an output with the specified initial value.
  ///
  /// - Parameter initialValue: The initial value of the pin.
  static func configure(initialValue: DigitalValue)

  /// The current value of the pin.
  static var value: DigitalValue { get set }

  /// Toggle the current value.
  static func toggle()
}