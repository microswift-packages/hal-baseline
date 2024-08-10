/// Describes the physical package of a microcontroller.
public protocol Packaging {
    associatedtype Chip: HAL.Chip
}
