import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        showSearchBar()
    }
    
}

extension AppCoordinator {
    
    func showSearchBar() {
        let appListViewModel = AppListViewModel()
        let listCellViewModel = ListCellViewModel()
        let appListViewController = AppListViewController(viewModel: appListViewModel, cellViewModel: listCellViewModel)
        
        rootViewController.pushViewController(appListViewController, animated: true)
    }
    
}
