import Foundation
import RxSwift

final class AppDetailViewModel {
    
    struct Output {
        
        let titleItems: Observable<App>
        
    }
    
    private let app: App?
    
    init(app: App) {
        self.app = app
    }
    
    func transform() -> Output {
        let appItems = configureAppItemsObservable()
        
        let ouput = Output(titleItems: appItems)
        
        return ouput
    }
    
    private func configureAppItemsObservable() -> Observable<App> {
        guard let app = app else { return Observable.just(App()) }

        return Observable.just(app)
    }

}

