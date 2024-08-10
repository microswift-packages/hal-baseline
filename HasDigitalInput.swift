/// Indicates that this value has a ``DigitalInput``. It is recommended that this protocol be supported by
/// any type which has a ``DigitalInput``, as well as those containing a single ``DigitalInput``.
/// It then allows other functions to be written generically over any type which implements ``HasDigitalInput``.
public protocol HasDigitalInput {
  /// The ``DigitalInput`` type associated with this value.
  associatedtype DigitalInput: HAL.DigitalInput
}

// Adds conformance to ``HasDigitalInput`` to types which conform to ``DigitalInput``.
extension HasDigitalInput where Self: HAL.DigitalInput {
  /// The ``DigitalInput`` type associated with this value.
  public typealias DigitalInput = Self
}