import Foundation
import RxSwift

final class AppListViewModel {
    
    // MARK: - Nested Types
    struct Input {
        let searchButtonDidTap: Observable<String>
        let collectionViewDidScroll: Observable<IndexPath>
    }
    
    struct Output {
        let searchedApps: Observable<[App]>
        let nextSearchedApps: Observable<[App]>
    }
    
    // MARK: - Properties
    private var lastTerm: String!
    private var searchLimit = 40
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let searchedApps = configureSearchAppsObservable(with: input.searchButtonDidTap)
        let nextSearchedApps = configureNextSearchedAppsObservable(with: input.collectionViewDidScroll)
        let ouput = Output(searchedApps: searchedApps, nextSearchedApps: nextSearchedApps)
        
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
                let appsObservable = weakSelf.fetchApps(from: searchText).map { searchResult -> [App] in
                    guard let lastResult = searchResult.results.last else {
                        return []
                    }
                    weakSelf.lastTerm = lastResult.trackName
                    return searchResult.results
                }
                
                return appsObservable
            }
    }
    
    private func configureNextSearchedAppsObservable(
        with inputObserver: Observable<IndexPath>
    ) -> Observable<[App]> {
        inputObserver
            .filter { [weak self] indexPath in
                indexPath.row + 2 == self?.searchLimit
            }
            .flatMap { [weak self]  indexPath -> Observable<[App]> in
                guard let weakSelf = self else {
                    return Observable.just([])
                }
                let appsObservable = weakSelf.fetchApps(from: weakSelf.lastTerm).map { searchResult -> [App] in
                    guard let lastResult = searchResult.results.last else {
                        return []
                    }
                    weakSelf.lastTerm = lastResult.trackName
                    weakSelf.searchLimit += 40
                    
                    var result = searchResult.results
                    result.removeFirst()
                    
                    return result
                }
                
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

