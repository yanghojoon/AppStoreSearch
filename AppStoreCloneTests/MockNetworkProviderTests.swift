import RxSwift
import XCTest
@testable import AppStoreClone

class MockNetworkProviderTests: XCTestCase {
    
    let mockURLSession: URLSessionProtocol = MockURLSession()
    var sut: NetworkProvider!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkProvider(session: mockURLSession)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }

    func test_fetchData가_잘_작동하는지_테스트() throws {
        let expectation = XCTestExpectation(description: "fetchData 비동기 테스트")
        
        let observable = sut.fetchData(
            api: SearchAppListAPI(term: "FILCA"),
            decodingType: SearchResult.self
        )
        
        _ = observable
            .subscribe(onNext: { apps in
                guard let app = apps.results.first else { return }
                XCTAssertEqual(app.trackName, "FILCA - SLR 필름 카메라")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10)
    }

}
