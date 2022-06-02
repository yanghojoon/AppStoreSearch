import UIKit

class AppListViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.searchController = searchController
    }
}
