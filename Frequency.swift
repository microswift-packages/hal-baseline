/// Represents the frequency of a clock on a microcontroller..
public struct Frequency: Equatable {
  /// The frequency of the clock in Hertz.
  public let hertz: UInt32

  /// Creates a new `Frequency` with the given frequency in Hertz.
  /// - Parameter hertz: The frequency of the clock in Hertz.
  @inlinable @inline(__always)
  public init(hertz: UInt32) {
    self.hertz = hertz
  }

  /// Creates a new `Frequency` with the given frequency in kHz.
  /// - Parameter kilohertz: The frequency of the clock in kHz.
  @inlinable @inline(__always)
  public init(kilohertz: UInt32) {
    self.init(hertz: kilohertz * 1_000)
  }

  /// Creates a new `Frequency` with the given frequency in MHz.
  /// - Parameter megahertz: The frequency of the clock in MHz.
  @inlinable @inline(__always)
  public init(megahertz: UInt32) {
    self.init(hertz: megahertz * 1_000_000)
  }

  /// The frequency of the clock in kHz.
  @inlinable @inline(__always)
  public var kilohertz: UInt32 {
    return hertz / 1_000
  }

  /// The frequency of the clock in MHz.
  @inlinable @inline(__always)
  public var megahertz: UInt32 {
    return hertz / 1_000_000
  }
}

extension Frequency: ExpressibleByIntegerLiteral {
  /// Creates a new `Frequency` with the given frequency in Hertz.
  @inlinable @inline(__always)
  public init(integerLiteral value: UInt32) {
    self.init(hertz: value)
  }
}

extension Frequency: RawRepresentable {
  /// Creates a new `Frequency` with the given frequency in Hertz.
  @inlinable @inline(__always)
  public init?(rawValue: UInt32) {
    self.init(hertz: rawValue)
  }

  /// The frequency in Hertz.
  @inlinable @inline(__always)
  public var rawValue: UInt32 {
    return hertz
  }
}

// List of common clock frequencies in AVR8 microcontrollers.
extension Frequency {
  /// 4 MHz
  @inlinable @inline(__always)
  public static var at4MHz: Frequency { .init(megahertz: 4) }
  
  /// 8 MHz
  @inlinable @inline(__always)
  public static var at8MHz: Frequency { .init(megahertz: 8) }

  /// 10 MHz
  @inlinable @inline(__always)
  public static var at10MHz: Frequency {.init(megahertz: 10) }
  
  /// 16 MHz
  @inlinable @inline(__always)
  public static var at16MHz: Frequency { .init(megahertz: 16) }
  
  /// 20 MHz
  @inlinable @inline(__always)
  public static var at20MHz: Frequency { .init(megahertz: 20) }
}
