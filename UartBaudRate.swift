  /// The baud rate of the UART, in bits per second.
  public enum UartBaudRate {
    /// 300 bits per second.
    case at300bps
    /// 600 bits per second.
    case at600bps
    /// 1,200 bits per second.
    case at1_2kbps
    /// 2,400 bits per second.
    case at2_4kbps
    /// 4,800 bits per second.
    case at4_8kbps
    /// 9,600 bits per second.
    case at9_6kbps
    /// 14,400 bits per second.
    case at14_4kbps
    /// 19,200 bits per second.
    case at19_2kbps
    /// 28,800 bits per second.
    case at28_8kbps
    /// 38,400 bits per second.
    case at38_4kbps
    /// 57,600 bits per second.
    case at57_6kbps
    /// 76,800 bits per second.
    case at76_8kbps
    /// 115,200 bits per second.
    case at115_2kbps
    /// 230,400 bits per second.
    case at230_4kbps
    /// 250,000 bits per second.
    case at250kbps
    /// 500,000 bits per second.
    case at500kbps
    /// 1,000,000 bits per second.
    case at1Mbps
    /// 2,000,000 bits per second.
    case at2Mbps
    /// A custom baud rate, in bits per second.
    case at(bps: UInt32)

    /// The baud rate in bits per second.
    @inlinable @inline(__always)
    public var bitsPerSecond: UInt32 {
      switch self {
      case .at300bps:
        return 300
      case .at600bps:
        return 600
      case .at1_2kbps:
        return 1_200
      case .at2_4kbps:
        return 2_400
      case .at4_8kbps:
        return 4_800
      case .at9_6kbps:
        return 9_600
      case .at14_4kbps:
        return 14_400
      case .at19_2kbps:
        return 19_200
      case .at28_8kbps:
        return 28_800
      case .at38_4kbps:
        return 38_400
      case .at57_6kbps:
        return 57_600
      case .at76_8kbps:
        return 76_800
      case .at115_2kbps:
        return 115_200
      case .at230_4kbps:
        return 230_400
      case .at250kbps:
        return 250_000
      case .at500kbps:
        return 500_000
      case .at1Mbps:
        return 1_000_000
      case .at2Mbps:
        return 2_000_000
      case .at(bps: let value):
        return value
      }
    }
  }
