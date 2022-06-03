import Foundation

struct AppStoreBaseURL: BaseURLProtocol {
    
    let url = "https://itunes.apple.com/"
    
}

struct SearchAppListAPI: APIProtocol {
    
    let url: URL?
    let method: HttpMethod = .get
    private let searchLimit = 30
    
    init(base: BaseURLProtocol = AppStoreBaseURL(), path: String = "search", term: String) {
        var urlComponents = URLComponents(string: "\(base.url)\(path)")
        let queryItems = [
            URLQueryItem(name: "country", value: "kr"),
            URLQueryItem(name: "media", value: "software"),
            URLQueryItem(name: "limit", value: "\(searchLimit)"),
            URLQueryItem(name: "term", value: term)
        ]
        urlComponents?.queryItems = queryItems
        
        self.url = urlComponents?.url
    }
    
}
