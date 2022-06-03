import XCTest
@testable import AppStoreClone

class JSONParserTests: XCTestCase {
    
    func test_SearchResult타입_decode했을때_Nil이_아닌지_테스트() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MockSearchResult", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
            XCTFail()
            return
        }
        
        let data = jsonString.data(using: .utf8)
        guard let result = JSONParser<SearchResult>().decode(from: data) else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.resultCount, 1)
        XCTAssertEqual(result.results[0].trackName, "FILCA - SLR 필름 카메라")
    }
    
}
