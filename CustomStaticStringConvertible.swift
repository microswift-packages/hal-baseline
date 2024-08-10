/// A type with a customised textual representation.
///
/// When you create a custom type, you can provide a custom textual representation for that type to
/// be used when it is written to an output stream, such as the standard output or when converted to
/// a string for any other purpose. To do this, make your type conform to the `CustomStaticStringConvertible`
/// protocol. This protocol requires you to provide a single read-only computed property, `staticDescription`,
/// which returns a `StaticString` value.
public protocol CustomStaticStringConvertible {
  /// A textual representation of this instance.
  ///
  /// The textual representation is used when your type is written to an output stream, such as the
  /// standard output or when converted to a string for any other purpose. The textual representation
  /// is always used verbatim; do not include any formatting characters.
  @inlinable @inline(__always)
  var staticDescription: StaticString { get }
}

/// Adds a default conformance of `CustomStaticStringConvertible` to `StaticString`.
extension StaticString: CustomStaticStringConvertible {
  /// Returns itself.
  @inlinable @inline(__always)
  public var staticDescription: StaticString { self }
}