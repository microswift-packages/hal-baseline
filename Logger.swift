/// Provides a logging interface for the HAL.
///
/// A logger requires a name, a logging level, and a printer. The printer is responsible for printing the logger name.
/// The most common wait to create a `Logger` is via the `logger(named:level:)` method on `AsyncSerial`.
///
/// ```swift
/// var serial = AsyncSerial<SomeBoard>()
/// serial.begin(baudRate: .at57_6kbps)
/// let log = serial.logger(named: "MyLogger", level: .debug)
/// ```
///
/// The logger can then be used to print messages.
///
/// ```swift
/// log?.debug("This is a debug message.")
/// log?.info("This is an info message.")
/// log?.warn("This is a warning message.")
/// log?.error("This is an error message.")
/// log?.fatal("This is a fatal message.")
/// ```
///
/// There are two special levels: `.never` and `.fatal`.
/// 
/// Creating a logger with a level of `.never` will disable all logging. Theoretically, you could also
/// try to print a message with a level of `.never`, but this will never be printed.
///
/// When creating a logger with a level of `.never` via ``AsyncSerial/logger(named:level:)``, `nil` will be returned.
/// 
/// Using the ``Logger/fatal(_:as:label:)`` method will print a fatal message, and never return. This is handy
/// for when you want to print a fatal message, but don't want to continue processing afterwards.
/// If you just want to log an error and keep rolling, use ``Logger/error(_:as:label:)``.
public struct Logger {
  public enum Level: UInt8, Comparable {
    /// Debug messages are generally not printed in production.
    case debug = 0
    /// Info messages are used to indicate that something happened.
    case info
    /// Warning messages are used to indicate that something unexpected happened.
    case warn
    /// Error messages are used to indicate that something went wrong.
    case error
    /// Fatal messages are used to indicate that something went wrong, and the program cannot continue.
    case fatal
    /// A special case that will never be printed.
    case never

    @inlinable @inline(__always)
    public static func < (lhs: Level, rhs: Level) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }

    /// The label to print.
    @inlinable @inline(__always)
    public var label: StaticString {
      switch self {
      case .debug:
        return "DEBUG"
      case .info:
        return " INFO"
      case .warn:
        return " WARN"
      case .error:
        return "ERROR"
      case .fatal:
        return "FATAL"
      case .never:
        return "     "
      }
    }
  }

  // MARK: - Instance Variables

  /// The logger name.
  @usableFromInline
  let name: StaticString

  /// The logging level that will be checked. If `nil`, the global logging level will be checked.
  @usableFromInline
  let level: Level

  @usableFromInline
  let printer: Printer

  /// Initializes a new logger.
  ///
  /// - Parameter name: The logger name.
  /// - Parameter level: The logger's logging level. If `nil`, the global logging level will be used.
  /// - Parameter printer: The printer to use.
  @inlinable @inline(__always)
  public init(name: StaticString, level: Level, printer: Printer) {
    self.name = name
    self.level = level
    self.printer = printer
  }

  // MARK: - Printing

  /// Prints the logger name and level.
  @inlinable @inline(__always)
  public func printLabel(for level: Level) {
    printer.print(level.label)
    printer.print(" [")
    printer.print(name)
    printer.print("] ")
  }

  /// Prints a value with a formatter at the specified level.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter level: The logging level to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func print<Value>(
    _ value: @autoclosure () -> Value, as formatter: @autoclosure () -> Formatter<Value>, level: Level, label: Bool = true
  ) {
    guard level != .never, self.level <= level else { return }
    if label { printLabel(for: level) }
    printer.print(value(), as: formatter())
  }

  /// Prints a value with a default formatter, at the specified level.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter level: The logging level to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func print<Value: DefaultFormatterProvider>(
    _ value: @autoclosure () -> Value, level: Level, label: Bool = true
  ) {
    guard level != .never, self.level <= level else { return }
    print(value(), as: Value.defaultFormatter, level: level, label: label)
  }

  /// Prints a value with a formatter, at the specified level, followed by a newline.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter level: The logging level to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func println<Value>(
    _ value: @autoclosure () -> Value, as formatter: @autoclosure () -> Formatter<Value>, level: Level, label: Bool = true
  ) {
    guard level != .never, self.level <= level else { return }
    print(value(), as: formatter(), level: level, label: label)
    printer.println()
  }

  /// Prints a value with a default formatter, at the specified level, followed by a newline.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter level: The logging level to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func println<Value: DefaultFormatterProvider>(
    _ value: @autoclosure () -> Value, level: Level, label: Bool = true
  ) {
    guard level != .never, self.level <= level else { return }
    println(value(), as: Value.defaultFormatter, level: level, label: label)
  }

  /// Prints a newline at the specified level.
  ///
  /// - Parameter level: The logging level to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func println(level: Level, label: Bool = true) {
    guard level != .never, self.level <= level else { return }
    println("", level: level, label: label)
  }

  // MARK: - Logging Functions

  /// Prints a debug message.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func debug<T>(_ value: @autoclosure () -> T, as formatter: @autoclosure () -> Formatter<T>, label: Bool = true) {
    println(value(), as: formatter(), level: .debug, label: label)
  }

  /// Prints a debug message with a default formatter.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func debug<T: DefaultFormatterProvider>(_ value: @autoclosure () -> T, label: Bool = true) {
    println(value(), level: .debug, label: label)
  }

  /// Prints an info message.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func info<T>(_ value: @autoclosure () -> T, as formatter: @autoclosure () -> Formatter<T>, label: Bool = true) {
    println(value(), as: formatter(), level: .info, label: label)
  }

  /// Prints an info message with a default formatter.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func info<T: DefaultFormatterProvider>(_ value: @autoclosure () -> T, label: Bool = true) {
    println(value(), level: .info, label: label)
  }

  /// Prints a warning message.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func warn<T>(_ value: @autoclosure () -> T, as formatter: @autoclosure () -> Formatter<T>, label: Bool = true) {
    println(value(), as: formatter(), level: .warn, label: label)
  }

  /// Prints a warning message with a default formatter.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func warn<T: DefaultFormatterProvider>(_ value: @autoclosure () -> T, label: Bool = true) {
    println(value(), level: .warn, label: label)
  }

  /// Prints an error message.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func error<T>(_ value: @autoclosure () -> T, as formatter: @autoclosure () -> Formatter<T>, label: Bool = true) {
    println(value(), as: formatter(), level: .error, label: label)
  }

  /// Prints an error message with a default formatter.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func error<T: DefaultFormatterProvider>(_ value: @autoclosure () -> T, label: Bool = true) {
    println(value(), level: .error, label: label)
  }

  /// Prints a fatal message, and never returns.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter formatter: The formatter to use.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func fatal<T>(_ value: @autoclosure () -> T, as formatter: @autoclosure () -> Formatter<T>, label: Bool = true, file: StaticString = #file, line: UInt = #line) -> Never {
    println(value(), as: formatter(), level: .fatal, label: label)
    while true {}
  }

  /// Prints a fatal message with a default formatter, and never returns.
  ///
  /// - Parameter value: The value to print.
  /// - Parameter label: Whether to print the logger name and level. (default: `true`)
  @inlinable @inline(__always)
  public func fatal<T: DefaultFormatterProvider>(_ value: @autoclosure () -> T, label: Bool = true) -> Never {
    println(value(), level: .fatal, label: label)
    while true {}
  }
}
