import UIKit

final class FlowCoordinator: Coordinator {
    
    // MARK: - Properties
    private let rootViewController: UINavigationController
    
    // MARK: - Initializers
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - Methods
    func start() {
        showSearchBar()
    }
    
}

// MARK: - Actions
extension FlowCoordinator {
    
    private func showSearchBar() {
        let actions = AppListViewAction(showDetailPage: showDetail(with:))
        let appListViewModel = AppListViewModel(actions: actions)
        let listCellViewModel = ListCellViewModel()
        let appListViewController = AppListViewController(viewModel: appListViewModel, cellViewModel: listCellViewModel)
        
        rootViewController.pushViewController(appListViewController, animated: true)
    }
    
    private func showDetail(with app: App) {
        let appDetailViewModel = AppDetailViewModel(app: app)
        let appDetailViewController = AppDetailViewController(viewModel: appDetailViewModel)
        
        rootViewController.pushViewController(appDetailViewController, animated: false)
    }
    
}
