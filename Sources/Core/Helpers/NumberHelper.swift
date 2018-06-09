import Foundation

public extension Double {
    
    public func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
}

public extension Array where Element == Double {
    
    public func average() -> Double {
        return Double(self.reduce(0, +)) / Double(self.count)
    }
    
}
