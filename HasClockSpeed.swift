/// A protocol for things that have a clock speed.
public protocol HasClockSpeed {
    /// The clock speed of the thing.
    static var clockSpeed: Frequency { get }
}