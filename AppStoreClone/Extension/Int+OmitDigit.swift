import Foundation

extension Int {
    
    var omitDigit: String {
        var result = String(self)
        let digitCount = String(self).count
        
        if digitCount <= 3 {
            return result
        } else if digitCount == 4 {
            let range = result.index(result.endIndex, offsetBy: -3)..<result.endIndex
            result.removeSubrange(range)
            result.append("천")
            
            return result
        } else {
            let range = result.index(result.endIndex, offsetBy: -4)..<result.endIndex
            result.removeSubrange(range)
            result.append("만")
            
            return result
        }
    }
    
}
