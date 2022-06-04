import Foundation
import RxSwift

final class AppListViewModel {
    
    // MARK: - Nested Types
    struct Input {
        let searchButtonDidTap: Observable<String>
        let collectionViewDidScroll: Observable<IndexPath>
        let cellDidSelect: Observable<String>
    }
    
    struct Output {
        let searchedApps: Observable<[HashableApp]>
        let nextSearchedApps: Observable<[HashableApp]>
    }
    
    // MARK: - Properties
    private let actions: AppListViewAction?
    private let disposeBag = DisposeBag()
    private var lastTerm: String!
    private var searchLimit = 40
    
    // MARK: - Initializers
    init(actions: AppListViewAction) {
        self.actions = actions
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let searchedApps = configureSearchAppsObservable(with: input.searchButtonDidTap)
        let nextSearchedApps = configureNextSearchedAppsObservable(with: input.collectionViewDidScroll)
        configureCellDidSelect(with: input.cellDidSelect)
        
        let ouput = Output(searchedApps: searchedApps, nextSearchedApps: nextSearchedApps)
        
        return ouput
    }
    
    private func configureSearchAppsObservable(
        with inputObserver: Observable<String>
    ) -> Observable<[HashableApp]> {
        inputObserver
            .flatMap { [weak self] searchText -> Observable<[HashableApp]> in
                guard let weakSelf = self else {
                    return Observable.just([])
                }
                let appsObservable = weakSelf.fetchApps(from: searchText).map { searchResult -> [HashableApp] in
                    guard let lastResult = searchResult.results.last else {
                        return []
                    }
                    weakSelf.lastTerm = lastResult.trackName
                    weakSelf.searchLimit = 40
                    return weakSelf.makeHashable(from: searchResult.results)
                }
                
                return appsObservable
            }
    }
    
    private func configureNextSearchedAppsObservable(
        with inputObserver: Observable<IndexPath>
    ) -> Observable<[HashableApp]> {
        inputObserver
            .filter { [weak self] indexPath in
                indexPath.row + 2 == self?.searchLimit
            }
            .flatMap { [weak self]  indexPath -> Observable<[HashableApp]> in
                guard let weakSelf = self else {
                    return Observable.just([])
                }
                let appsObservable = weakSelf.fetchApps(from: weakSelf.lastTerm).map { searchResult -> [HashableApp] in
                    guard let lastResult = searchResult.results.last else {
                        return []
                    }
                    weakSelf.lastTerm = lastResult.trackName
                    weakSelf.searchLimit += 39
                    
                    var result = searchResult.results
                    result.removeFirst()
                    
                    return weakSelf.makeHashable(from: result)
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
    
    private func makeHashable(from apps: [App]) -> [HashableApp] {
        var hashableApps = [HashableApp]()
        apps.forEach { app in
            let hashableApp = HashableApp(app: app)
            hashableApps.append(hashableApp)
        }
        
        return hashableApps
    }
    
    private func configureCellDidSelect(with inputObserver: Observable<String>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] appName in
                self?.actions?.showDetailPage(appName)
            })
            .disposed(by: disposeBag)
    }
    
}

