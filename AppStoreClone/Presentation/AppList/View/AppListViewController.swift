import UIKit
import RxSwift

class AppListViewController: UIViewController {
    
    // MARK: - Nested Types
    private enum SectionKind: Int {
        
        case main
        
        var columnCount: Int {
            switch self {
            case .main:
                return 1
            }
        }
        
    }
    
    // MARK: - Properties
    private let searchController = UISearchController()
    private let viewModel = AppListViewModel() // TODO: 의존성 주입으로 수정
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var diffableDataSource: UICollectionViewDiffableDataSource<SectionKind, App>!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionKind, App>!
    
    private let searchButtonDidTap = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSearchController()
        configureUI()
        configureCellRegistrationAndDataSource()
        bind()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Content.searchBarPlaceHolder
    }
    
    private func configureUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = createCollectionViewLayout()
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.15)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: sectionKind.columnCount
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }
    
    private func configureCellRegistrationAndDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, App> { cell, indexPath, app in
            cell.apply(
                logoImageURL: app.artworkUrl100,
                name: app.trackName,
                genre: app.primaryGenreName,
                averageUserRating: app.averageUserRating,
                userRatingCount: app.userRatingCount,
                formattedPrice: app.formattedPrice
            )
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<SectionKind, App>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, app in
                guard let sectionKind = SectionKind(rawValue: indexPath.section) else {
                    return UICollectionViewCell()
                }
                
                switch sectionKind {
                case .main:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration,
                        for: indexPath,
                        item: app
                    )
                }
            })
    }

}

// MARK: - SearchBar Delegate
extension AppListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        searchButtonDidTap.onNext(searchText)
    }
}

// MARK: - Rx Binding Methods
extension AppListViewController {
    private func bind() {
        let input = AppListViewModel.Input(searchButtonDidTap: searchButtonDidTap.asObservable())
        let output = viewModel.transform(input)
        
        configureSearchedApps(with: output.searchedApps)
    }
    
    private func configureSearchedApps(with searchedApps: Observable<[App]>) {
        searchedApps
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] apps in
                self?.configureSnapshot(with: apps)
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSnapshot(with apps: [App]) {
        snapshot = NSDiffableDataSourceSnapshot<SectionKind, App>()
        snapshot.appendSections([.main])
        snapshot.appendItems(apps)
        diffableDataSource.apply(snapshot)
    }
}

// MARK: - Namespaces
extension AppListViewController {
    private enum Content {
        static let searchBarPlaceHolder = "찾으시는 앱을 검색해주세요"
    }
}
