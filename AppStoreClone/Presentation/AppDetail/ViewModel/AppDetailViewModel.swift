import Foundation
import RxSwift

final class AppDetailViewModel {
    
    struct Input {
        
        let moreButtonDidTap: Observable<Void>
        let sharebuttonDidTap: Observable<Void>
        
    }
    
    struct Output {
        
        let items: Observable<App>
        let showMoreContent: Observable<Void>
        let showActivityViewController: Observable<String>
        
    }
    
    private let app: App?
    
    init(app: App) {
        self.app = app
    }
    
    func transform(_ input: Input) -> Output {
        let appItems = configureAppItemsObservable()
        let trackViewURL = configureShowActivityViewControllerObservable(with: input.sharebuttonDidTap)
        
        let ouput = Output(
            items: appItems,
            showMoreContent: input.moreButtonDidTap,
            showActivityViewController: trackViewURL)
        
        return ouput
    }
    
    private func configureAppItemsObservable() -> Observable<App> {
        guard let app = app else { return Observable.just(App()) }

        return Observable.just(app)
    }
    
    private func configureShowActivityViewControllerObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<String> {
        inputObserver
            .flatMap { [weak self] () -> Observable<String> in
                guard let app = self?.app else { return Observable.just("") }
                
                return Observable.just(app.trackViewUrl)
            }
    }

}

