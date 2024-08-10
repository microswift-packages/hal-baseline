/// A protocol that indicates a type has an ``OutputComparePin`` linked to it.
public protocol HasOutputComparePin {
  associatedtype OutputCompare: OutputComparePin
}
