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
    let trackId: Int
    let languageCodesISO2A: [String]
    let contentAdvisoryRating: String
    
}

struct HashableApp: Hashable {
    let app: App
    let uuid = UUID()
}
