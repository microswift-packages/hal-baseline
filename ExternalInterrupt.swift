/// An external interrupt is attached to a pin, and triggers when the pin changes state.
/// It can be configured to the options in ``ExternalInterruptSenseControl``.
public protocol ExternalInterrupt: Interrupt {
  /// Configures the interrupt to trigger on rising, falling, or both edges.
  ///
  /// - Parameter trigger: The event which will trigger the interrupt.
  /// - Parameter enabled: If `true`, the interrupt is enabled.
  static func configure(trigger: ExternalInterruptSenseControl)

  /// What event will trigger the interrupt?
  static var trigger: ExternalInterruptSenseControl { get }
}
