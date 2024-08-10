/// Represents a digital input pin.
public protocol DigitalInput {
  /// Configures the pin as an input with the specified pull-up resistor state.
  ///
  /// - Parameter pullup: The pull-up resistor state of the pin.
  static func configure(pullup: PullupState)

  /// The pull-up resistor state of the pin.
  static var pullup: PullupState { get }

  /// The value of the pin.
  static var value: DigitalValue { get }
}