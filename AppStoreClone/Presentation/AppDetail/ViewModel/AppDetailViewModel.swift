import Foundation
import RxSwift

final class AppDetailViewModel {
    
    struct Input {
        
        let moreButtonDidTap: Observable<Void>
        
    }
    
    struct Output {
        
        let titleItems: Observable<App>
        let showMoreContent: Observable<Void>
        
    }
    
    private let app: App?
    
    init(app: App) {
        self.app = app
    }
    
    func transform(_ input: Input) -> Output {
        let appItems = configureAppItemsObservable()
        
        let ouput = Output(titleItems: appItems, showMoreContent: input.moreButtonDidTap)
        
        return ouput
    }
    
    private func configureAppItemsObservable() -> Observable<App> {
        guard let app = app else { return Observable.just(App()) }

        return Observable.just(app)
    }

}

