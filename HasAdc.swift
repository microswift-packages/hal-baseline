/// A protocol for contexts that have a single/default ADC peripheral.
/// This includes a specific ADC unit, which would refer to itself.
public protocol HasAdc {
  /// The type of the ADC peripheral.
  associatedtype Adc: AdcPeripheral
}
