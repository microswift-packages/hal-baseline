/// Indicates that the type has an external interrupt.
public protocol HasExternalInterrupt {
  /// The external interrupt.
  associatedtype External: ExternalInterrupt
}
