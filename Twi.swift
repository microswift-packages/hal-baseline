public protocol Twi {
    associatedtype Twamr: MutableRegisterValue
    associatedtype Twcr: MutableRegisterValue
    associatedtype Twar: MutableRegisterValue
    associatedtype Twsr: MutableRegisterValue

    static var twamr: Twamr  { get set }
    static var twcr:  Twcr  { get set }
    static var twdr:  UInt8  { get set }
    static var twar:  Twar  { get set }
    static var twsr:  Twsr  { get set }
    static var twbr:  UInt8  { get set }
}
