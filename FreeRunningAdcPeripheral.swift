
/// An extension of ``AdcPeripheral`` that adds support for free running mode.
public protocol FreeRunningAdcPeripheral: SingleConversionAdcPeripheral {
  /// Configure the ADC peripheral with an auto trigger source.
  ///
  /// - Parameters:
  ///   - referenceVoltage: The reference voltage.
  ///   - prescaler: The prescaler.
  ///   - channel: The channel bitfield.
  @inlinable @inline(__always)
  static func configureFreeRunning(
    referenceVoltage: AdcReferenceVoltage, prescaler: AdcPrescaler)
}
