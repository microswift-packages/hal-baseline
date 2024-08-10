
/// An analog pin on a microcontroller which is connected to an ADC peripheral.
public protocol AdcAnalogPin: AnalogPin, HasAnalogPin {
  associatedtype Adc: AdcPeripheral

  /// The channel number of the analog pin.
  @inlinable @inline(__always)
  static var channel: Adc.ChannelSelect { get }
}

extension AdcAnalogPin {
  /// Default implementation for reading the analog value from the pin.
  @inlinable @inline(__always)
  public static var value: UInt16 {
    get {
      Adc.startConversion(on: channel)
      while !Adc.conversionComplete {}
      return Adc.data
    }
  }
}

extension AdcAnalogPin where Adc: SingleConversionAdcPeripheral {
  /// Configures the analog pin for input, in single conversion mode.
  ///
  /// - Parameters:
  ///   - referenceVoltage: The reference voltage.
  ///   - prescaler: The prescaler.
  @inlinable @inline(__always)
  public static func configure(referenceVoltage: AdcReferenceVoltage, prescaler: AdcPrescaler) {
    Adc.configureSingleConversion(
      referenceVoltage: referenceVoltage, prescaler: prescaler)
  }
}
