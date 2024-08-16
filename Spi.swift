public protocol Spi {
    associatedtype Spsr: MutableRegisterValue
    associatedtype Spcr: MutableRegisterValue

    static var spsr: Spsr  { get set }
    static var spdr: UInt8 { get set }
    static var spcr: Spcr  { get set }
}
