// A type that supports string interpolation via conformance to `ExpresibleByStringInterpolation`
// and outputs to a ``Printer``. It will accept any type that conforms to ``DefaultFormatterProvider``.
// It also allows passing in any value, as long as it also has a ``Formatter`` provided for it.

public struct PrintInterpolation: ExpressibleByStringInterpolation {

  /// The printer that any interpolations will output to.
  @usableFromInline
  static var out: Printer = Printer { _ in }

  public struct StringInterpolation: StringInterpolationProtocol {
    /// Initializes a new string interpolation.
    ///
    /// - Parameter literalCapacity: The maximum number of characters that the string interpolation can store without allocating more memory.
    /// - Parameter interpolationCount: The number of interpolations that will be appended.
    @inlinable @inline(__always)
    public init(literalCapacity: Int, interpolationCount: Int) {
      // we don't care because we will just dump to the printer as it comes in.
    }

    @inlinable @inline(__always)
    public func appendLiteral(_ literal: StaticString) {
      out.print(literal)
    }

    @inlinable @inline(__always)
    public func appendInterpolation<Value>(_ value: Value, as formatter: Formatter<Value>) {
      out.print(value, as: formatter)
    }

    @inlinable @inline(__always)
    public func appendInterpolation<Value: DefaultFormatterProvider>(_ value: Value) {
      out.print(value)
    }

    @inlinable @inline(__always)
    public func appendInterpolation(_ value: StaticString) {
      out.print(value, as: .staticString)
    }
  }

  @inlinable @inline(__always)
  public init(stringInterpolation: StringInterpolation) {}
}

// MARK: - Printer

extension Printer {
  /// Prints the provided ``PrintInterpolation``.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func print(_ interpolation: @autoclosure () -> PrintInterpolation) {
    PrintInterpolation.out = self
    let _ = interpolation()
    // Note: Not resetting PrintInterpolation.out to save bytes
  }

  /// Prints the provided ``PrintInterpolation`` with a newline.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func println(_ interpolation: @autoclosure () -> PrintInterpolation) {
    print(interpolation())
    println()
  }
}

// MARK: - Logger

extension Logger {
  /// Prints the provided ``PrintInterpolation``.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func print(
    _ interpolation: @autoclosure () -> PrintInterpolation, level: Level, label: Bool = true
  ) {
    guard level != .never, self.level <= level else { return }
    if label { printLabel(for: level) }
    self.printer.print(interpolation())
  }

  /// Prints the provided ``PrintInterpolation`` with a newline.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func println(
    _ interpolation: @autoclosure () -> PrintInterpolation, level: Level, label: Bool = true
  ) {
    print(interpolation(), level: level, label: label)
    printer.println()
  }

  /// Prints the provided ``PrintInterpolation`` at the debug level.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func debug(_ interpolation: @autoclosure () -> PrintInterpolation, label: Bool = true) {
    println(interpolation(), level: .debug, label: label)
  }

  /// Prints the provided ``PrintInterpolation`` at the info level.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func info(_ interpolation: @autoclosure () -> PrintInterpolation, label: Bool = true) {
    println(interpolation(), level: .info, label: label)
  }

  /// Prints the provided ``PrintInterpolation`` at the warning level.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func warning(_ interpolation: @autoclosure () -> PrintInterpolation, label: Bool = true) {
    println(interpolation(), level: .warn, label: label)
  }

  /// Prints the provided ``PrintInterpolation`` at the error level.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func error(_ interpolation: @autoclosure () -> PrintInterpolation, label: Bool = true) {
    println(interpolation(), level: .error, label: label)
  }

  /// Prints the provided ``PrintInterpolation`` at the fatal level.
  ///
  /// - Parameter interpolation: The ``PrintInterpolation`` to print.
  @inlinable @inline(__always)
  public func fatal(_ interpolation: @autoclosure () -> PrintInterpolation, label: Bool = true) {
    println(interpolation(), level: .fatal, label: label)
  }
}
