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
        
        let countryQuery = URLQueryItem(name: "country", value: "kr")
        let mediaQuery = URLQueryItem(name: "media", value: "software")
        let limitQuery = URLQueryItem(name: "limit", value: "\(searchLimit)")
        let termQuery = URLQueryItem(name: "term", value: term)
        let queries: [URLQueryItem] = [countryQuery, mediaQuery, limitQuery, termQuery]
        
        queries.forEach { urlComponents?.queryItems?.append($0) }
        
        self.url = urlComponents?.url
    }
    
}
