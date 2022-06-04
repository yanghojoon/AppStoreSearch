import Foundation
import UIKit

class FlowCoordinator: Coordinator {
    
    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        showSearchBar()
    }
    
}

extension FlowCoordinator {
    
    func showSearchBar() {
        let actions = AppListViewAction(showDetailPage: showDetail(with:))
        let appListViewModel = AppListViewModel(actions: actions)
        let listCellViewModel = ListCellViewModel()
        let appListViewController = AppListViewController(viewModel: appListViewModel, cellViewModel: listCellViewModel)
        
        rootViewController.pushViewController(appListViewController, animated: true)
    }
    
    func showDetail(with app: App) {
        let appDetailViewModel = AppDetailViewModel(app: app)
        let appDetailViewController = AppDetailViewController(viewModel: appDetailViewModel)
        
        rootViewController.pushViewController(appDetailViewController, animated: true)
    }
    
}
