import Foundation
import RxSwift

final class AppListViewModel {
    
    // MARK: - Nested Types
    struct Input {
        let searchButtonDidTap: Observable<String>
    }
    
    struct Output {
        let searchedApps: Observable<[App]>
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let searchedApps = configureSearchAppsObservable(with: input.searchButtonDidTap)
        let ouput = Output(searchedApps: searchedApps)
        
        return ouput
    }
    
    private func configureSearchAppsObservable(
        with inputObserver: Observable<String>
    ) -> Observable<[App]> {
        inputObserver
            .flatMap { [weak self] searchText -> Observable<[App]> in
                guard let weakSelf = self else {
                    return Observable.just([])
                }
                let appsObservable = weakSelf.fetchApps(from: searchText).map { $0.results }
                
                return appsObservable
            }
    }
    
    private func fetchApps(from term: String) -> Observable<SearchResult> {
        let networkProvider = NetworkProvider()
        let observable = networkProvider.fetchData(
            api: SearchAppListAPI(term: term),
            decodingType: SearchResult.self
        )
        return observable
    }
    
}

