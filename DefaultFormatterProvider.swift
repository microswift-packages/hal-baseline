/// A ``DefaultFormatterProvider`` is a type that provides a default ``Formatter``.
public protocol DefaultFormatterProvider {
  /// The default formatter for this type.
  static var defaultFormatter: Formatter<Self> { get }
}