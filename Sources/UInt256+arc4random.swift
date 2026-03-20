//

import Foundation

public func arc4random_uniform<T>(_ upperBound: T) -> T where T: FixedWidthInteger & UnsignedInteger {
    if upperBound == 0 {
        return T.min
    }
    if upperBound.bitWidth <= 64 {
        let result = arc4random_uniform64(UInt64(truncatingIfNeeded: upperBound))
        return T(truncatingIfNeeded: result)
    }

    // for the sake of this library, treat it as UInt256
    let result: UInt256 = arc4random_uniform256(upperBound as! UInt256)
    return result as! T
}

func arc4random_uniform64(_ upperBound: UInt64) -> UInt64 {
    guard upperBound > 0 else {
        return 0
    }
    return UInt64.random(in: 0..<upperBound)
}

func arc4random_uniform256(_ upperBound: UInt256) -> UInt256 {
    var result: UInt256
    switch upperBound.leadingZeroBitCount {
    case 0..<64:
        result = UInt256([arc4random_uniform64(upperBound[0]), arc4random64(), arc4random64(), arc4random64()])
    case 64..<128:
        result = UInt256([0, arc4random_uniform64(upperBound[1]), arc4random64(), arc4random64()])
    case 128..<192:
        result = UInt256([0, 0, arc4random_uniform64(upperBound[2]), arc4random64()])
    default:
        result = UInt256([0, 0, 0, arc4random_uniform64(upperBound[3])])
    }
    while result >= upperBound {
        result = arc4random_uniform256(upperBound)
    }

    return result
}

func arc4random64() -> UInt64 {
    UInt64.random(in: UInt64.min...UInt64.max)
}

func arc4random256() -> UInt256 {
    return UInt256([arc4random64(), arc4random64(), arc4random64(), arc4random64()])
}
