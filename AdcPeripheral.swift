/// A protocol for ADC peripherals. It provides a common interface for ADC peripherals,
/// with functions for configuring the ADC and reading the result of a conversion.
/// The protocol is generic over the type of the channel bitfield.
public protocol AdcPeripheral {
  /// The type of the channel bitfield.
  associatedtype ChannelSelect: Bitfield

  associatedtype ConversionCompleteInterrupt: Interrupt where ConversionCompleteInterrupt.Source == Self

  /// Has the ADC been enabled?
  @inlinable @inline(__always)
  static var enabled: Bool { get set }

  /// Start a conversion.
  @inlinable @inline(__always)
  static func startConversion(on channel: ChannelSelect)

  /// The ADC conversion complete flag.
  /// This flag is set when a conversion is complete.
  @inlinable @inline(never)
  static var conversionComplete: Bool { get }

  /// Read a full 10-bit value from the ADC.
  /// If the ADC is configured to left adjust the result, the value will be in the upper 10 bits of the returned value.
  @inlinable @inline(__always)
  static var data: UInt16 { get }
}

// TODO: Support other auto trigger modes.
