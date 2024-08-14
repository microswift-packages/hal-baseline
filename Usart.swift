public protocol Usart {
    static var ucsra: UInt8  { get set }
    static var ucsrb: UInt8  { get set }
    static var ucsrc: UInt8  { get set }
    static var udr:   UInt8  { get set }
    static var ubrr:  UInt16 { get set }
}
