
// Allow AsyncSerial to configure logging.
extension AsyncSerial {
  /// Configures the logging functions to use the serial port.
  /// If specifying a level of `.never`, no logger is returned.
  /// This makes it simple to disable all logging like so:
  ///
  /// ```swift
  /// var serial = AsyncSerial<SomeBoard>()
  /// serial.begin(baudRate: .at57_6kbps)
  /// let log = serial.logger(named: "MyLogger", level: .never)
  ///
  /// log?.debug("This will not be printed.")
  /// ```
  ///
  /// - Parameter name: The name of the logger.
  /// - Parameter level: The logging level to use.
  /// - Returns: A logger that prints to the serial port, or `nil` if the logging level is `.never`.
  @inlinable @inline(__always)
  public func logger(named name: @autoclosure () -> StaticString, level: Logger.Level) -> Logger? {
    guard level != .never else { return nil }
    return Logger(name: name(), level: level, printer: self.printer)
  }
}
