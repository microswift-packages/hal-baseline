/// Indicates that the type can be monitored for changes.
public protocol HasMonitorPin {
    /// The external interrupt.
    associatedtype Monitor: MonitorPin
}

// Adds automatic conformance to ``HasMonitorPin`` for types that are also conform to ``MonitorPin``.
extension HasMonitorPin where Self: MonitorPin {
    /// The pin change interrupt.
    typealias Monitor = Self
}