import Foundation

struct App: Decodable, Hashable {
    
    let trackName: String
    let artworkUrl100: String
    let screenshotUrls: [String]
    let primaryGenreName: String
    let averageUserRating: Double
    let userRatingCount: Int
    let formattedPrice: String
    let artistName: String
    let fileSizeBytes: String
    let description: String
    let languageCodesISO2A: [String]
    let contentAdvisoryRating: String
    let trackViewUrl: String
    
}

extension App {
    
    init() {
        self.trackName = ""
        self.artworkUrl100 = ""
        self.screenshotUrls = []
        self.primaryGenreName = ""
        self.averageUserRating = 0
        self.userRatingCount = 0
        self.formattedPrice = ""
        self.artistName = ""
        self.fileSizeBytes = ""
        self.description = ""
        self.languageCodesISO2A = []
        self.contentAdvisoryRating = ""
        self.trackViewUrl = ""
    }
    
}

struct HashableApp: Hashable {
    let app: App
    let uuid = UUID()
}
