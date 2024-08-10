/// Indicates that this value has a ``DigitalOutput``. It is recommended that this protocol be supported by
/// any type which has a ``DigitalOutput``, as well as those containing a single ``DigitalOutput``.
/// It then allows other functions to be written generically over any type which implements ``HasDigitalOutput``.
public protocol HasDigitalOutput {
  /// The ``DigitalOutput`` type associated with this value.
  associatedtype DigitalOutput: HAL.DigitalOutput
}

// Adds conformance to ``HasDigitalOutput`` to types which conform to ``DigitalOutput``.
extension HasDigitalOutput where Self: HAL.DigitalOutput {
  /// The ``DigitalOutput`` type associated with this value.
  public typealias DigitalOutput = Self
}