extension FixedWidthInteger {
    /// Creates a bitmask for a given `FixedWidthInteger` type, within the specified range.
    ///
    /// - Parameter range: The range of bits to include in the mask. (eg. `0...3`)
    /// - Returns: The bitmasked value of the same type as the input value.
    @inlinable @inline(__always)
    public static func bitmask(from range: ClosedRange<Int>) -> Self {
        // precondition(range.lowerBound <= range.upperBound, "bitmask range lower bound must be less than or equal to the upper bound")
        // precondition(range.lowerBound >= 0, "bitmask range lower bound must be greater than or equal to zero")
        // precondition(range.upperBound < T.bitWidth, "bitmask range upper bound must be less than \(T.bitWidth)")
        let allBits: Self = ~0
        let mask: Self = allBits << range.lowerBound & allBits >> (Self.bitWidth - 1 - range.upperBound)
        return mask
    }
}
