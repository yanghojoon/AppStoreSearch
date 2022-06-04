import Foundation
import RxSwift

final class AppDetailViewModel {
    struct Input {
        let viewDidLoadDidInvoke: Observable<Void>
    }
    
    struct Output {
        let appItems: Observable<App>
    }
    
    private let app: App?
    
    init(app: App) {
        self.app = app
    }
    
    func transform(_ input: Input) -> Output {
        let appItems = configureAppItemsObservable(with: input.viewDidLoadDidInvoke)
        
        let ouput = Output(appItems: appItems)
        
        return ouput
    }
    
    private func configureAppItemsObservable(with inputObserver: Observable<Void>) -> Observable<App> {
        guard let app = app else { return Observable.just(App()) }

        return Observable.just(app)
    }
}

