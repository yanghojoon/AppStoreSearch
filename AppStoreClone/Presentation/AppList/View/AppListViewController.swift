import UIKit

class AppListViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.searchController = searchController
    }

}
