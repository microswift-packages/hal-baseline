/// Indicates that this value has an ``AnalogPin``. It is recommended that this protocol be supported by
/// any type which has a single/default ``AnalogPin``, as well as any actual ``AnalogPin`` types, which
/// just return themselves from the `analog` property.
public protocol HasAnalogPin {
  /// The type of the analog pin.
  associatedtype Analog: AnalogPin
}
