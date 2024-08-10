extension UnsafeMutableRawBufferPointer {
  /// Returns a boolean indicating whether the buffer ends with the provided `UnsafeRawBufferPointer`.
  ///
  /// - Parameter terminator: The terminator to check for.
  /// - Returns: `true` if the buffer ends with the terminator, `false` otherwise.
  @inlinable @inline(__always)
  public func ends(with terminator: UnsafeRawBufferPointer) -> Bool {
    guard terminator.count <= self.count else { return false }
    return self.suffix(terminator.count).elementsEqual(terminator)
  }
}
