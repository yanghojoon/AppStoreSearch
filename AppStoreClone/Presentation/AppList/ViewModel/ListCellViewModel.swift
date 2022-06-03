import Foundation

class ListCellViewModel { }

extension ListCellViewModel: ListCellDelegate {
    
    func countStar(from rating: Double) -> (empty: Int, fill: Int, half: Int) {
        let starCount = 5
        let roundedRating = round(rating * 10) / 10
        
        if roundedRating.truncatingRemainder(dividingBy: 1) == 0 {
            let fillCount = Int(roundedRating.truncatingRemainder(dividingBy: 5))
            let emptyCount = starCount - fillCount
            
            return (empty: emptyCount, fill: fillCount, half: 0)
        } else {
            let fillCount = Int(roundedRating.truncatingRemainder(dividingBy: 5))
            let halfCount = 1
            let emptyCount = starCount - fillCount - halfCount
            
            return (empty: emptyCount, fill: fillCount, half: halfCount)
        }
    }
    
}
