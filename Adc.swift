public protocol Adc {
    associatedtype Admux: MutableRegisterValue
    associatedtype Adcsra: MutableRegisterValue
    associatedtype Adcsrb: MutableRegisterValue

    static var admux:   Admux   { get set }
    static var adc:     UInt16  { get set }
    static var adcsra:  Adcsra  { get set }
    static var adcsrb:  Adcsrb  { get set }
}
