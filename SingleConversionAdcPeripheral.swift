/// An extension of ``AdcPeripheral`` that adds support for single conversion mode and a reference voltage/prescaler.
public protocol SingleConversionAdcPeripheral: AdcPeripheral {
  /// Configure the ADC peripheral.
  ///
  /// - Parameters:
  ///   - referenceVoltage: The reference voltage.
  ///   - prescaler: The prescaler.
  @inlinable @inline(__always)
  static func configureSingleConversion(
    referenceVoltage: AdcReferenceVoltage, prescaler: AdcPrescaler)

  /// The reference voltage for the ADC.
  @inlinable @inline(__always)
  static var referenceVoltage: AdcReferenceVoltage { get }

  /// The prescaler for the ADC clock.
  @inlinable @inline(__always)
  static var prescaler: AdcPrescaler { get }

  /// The ADC left adjust result flag.
  /// When set, the ADC result is left adjusted.
  /// This means that the result is stored in the upper bits of the data register.
  @inlinable @inline(__always)
  static var leftAdjustResult: Bool { get set }
}
