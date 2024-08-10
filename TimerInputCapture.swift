/// A protocol for input capture units on ``TimerPeripheral`` instances.
public protocol TimerInputCapture {
  /// The timer type.
  associatedtype Timer: TimerPeripheral

  /// The type of the interrupt that is triggered when the input capture value is updated.
  associatedtype UpdateInterrupt: Interrupt where UpdateInterrupt.Source == Timer

  /// The type of the timer's counter value.
  typealias Counter = Timer.Counter

  /// The input capture value.
  @inlinable @inline(__always)
  static var value: Counter { get set }

  /// Configures the input capture unit.
  ///
  /// - Parameters:
  ///   - noiseCancelerEnabled: If `true`, the noise canceler is enabled.
  ///   - captureEdge: The input capture edge select.
  @inlinable @inline(__always)
  static func configure(noiseCancelerEnabled: Bool, captureEdge: TimerInputCaptureEdgeSelect)

  /// Is the noise canceler enabled?
  @inlinable @inline(__always)
  static var noiseCancelerEnabled: Bool { get }

  /// Is the input capture edge select set to rising edge?
  @inlinable @inline(__always)
  static var captureEdge: TimerInputCaptureEdgeSelect { get }
}
