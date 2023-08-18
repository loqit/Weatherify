import Foundation

extension ClosedRange {

    static func ~= (lhs: Self, rhs: Self) -> Bool {
        (lhs.lowerBound >= rhs.lowerBound && lhs.lowerBound <= rhs.upperBound) ||
        (lhs.upperBound >= rhs.lowerBound && lhs.upperBound <= rhs.upperBound)
    }
}
