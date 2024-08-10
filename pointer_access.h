#include <stdint.h>

// static inline uint8_t _volatileRegisterRead(volatile uint8_t *ptr) { return *ptr; }
// static inline void _volatileRegisterWrite(volatile uint8_t *ptr, uint8_t value) { *ptr = value; }
// static inline uint16_t _volatileWideRead(volatile uint16_t *ptr) { return *ptr; }
// static inline void _volatileWideWrite(volatile uint16_t *ptr, uint16_t value) { *ptr = value; }

/**
 * @brief Read a 32-bit value from a volatile pointer.
 * @param ptr The pointer to read from.
 * @return The value read.
 */
static inline uint8_t _volatileRegisterReadUInt8(uintptr_t address)
{
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  return *ptr;
}

/**
 * @brief Write a 32-bit value to a volatile pointer.
 * @param ptr The pointer to write to.
 * @param value The value to write.
 */
static inline void _volatileRegisterWriteUInt8(uintptr_t address, uint8_t value)
{
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  *ptr = value;
}

/**
 * @brief Read a 32-bit value from a volatile pointer.
 * @param ptr The pointer to read from.
 * @return The value read.
 */
static inline uint16_t _volatileRegisterReadUInt16(uintptr_t address)
{
  volatile uint16_t *ptr = (volatile uint16_t *)address;
  return *ptr;
}

/**
 * @brief Write a 32-bit value to a volatile pointer.
 * @param ptr The pointer to write to.
 * @param value The value to write.
 */
static inline void _volatileRegisterWriteUInt16(uintptr_t address, uint16_t value)
{
  volatile uint16_t *ptr = (volatile uint16_t *)address;
  *ptr = value;
}
