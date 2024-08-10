/// Defines the effect that a compare match has on the output pin.
/// This is known as the "Compare Output Mode" (`COMnX1:0`) in the datasheet.
///
/// This is a somewhat complex set of options, since the behaviour
/// is slightly different depending on the mode. Also, not every option
/// is available on every comparison register.
///
/// Here is a table that summarises the behaviour:
///
/// | Mode | Normal / CTC | Fast PWM | Phase Correct PWM |
/// | ---- | ------  | -------- | ----------------- |
/// | `.none` | Pin disconnected. | Pin disconnected. | Pin disconnected. |
/// | `.toggleOnMatch` | Toggle pin on compare match. | If `top` is `.compareRegister`, toggle pin on compare match. Otherwise, pin disconnected. | If `top` is `.compareRegister`, toggle pin on compare match. Otherwise, pin disconnected. |
/// | `.clearOnMatch` | Clear pin on compare match. | Clear pin on compare match, set pin at `bottom`. (non-inverting mode) | Clear pin on compare match when counting up, set pin on compare match when counting down. |
/// | `.setOnMatch` | Set pin on compare match. | Set pin on compare match, clear pin at `bottom`. (inverting mode) | Set pin on compare match when counting up, clear pin on compare match when counting down. |
///
/// There are some additional special cases as well, so check the datasheet for details.
public enum OutputComparePinEffect: UInt8, Bitfield {
  case none = 0x00
  case toggleOnMatch = 0x01
  case clearOnMatch = 0x02
  case setOnMatch = 0x03
}
