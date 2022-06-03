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
    private var diffableDataSource: UICollectionViewDiffableDataSource<SectionKind, HashableApp>!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionKind, HashableApp>!
    
    private let searchButtonDidTap = PublishSubject<String>()
    private let collectionViewDidScroll = PublishSubject<IndexPath>()
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
        collectionView.delegate = self
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
            
            let screenHeight = UIScreen.main.bounds.height
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            var groupSize: NSCollectionLayoutSize
            if screenHeight < 750 {
                groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.15)
                )
            } else {
                groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.11)
                )
            }
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
        let cellRegistration = UICollectionView.CellRegistration<ListCell, HashableApp> { cell, indexPath, hashable in
            cell.apply(
                logoImageURL: hashable.app.artworkUrl100,
                name: hashable.app.trackName,
                genre: hashable.app.primaryGenreName,
                averageUserRating: hashable.app.averageUserRating,
                userRatingCount: hashable.app.userRatingCount,
                formattedPrice: hashable.app.formattedPrice
            )
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<SectionKind, HashableApp>(
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

// MARK: - CollectionView Delegate
extension AppListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let listCell = cell as? ListCell else { return }
        collectionViewDidScroll.onNext(indexPath)
    }
}

// MARK: - Rx Binding Methods
extension AppListViewController {
    
    private func bind() {
        let input = AppListViewModel.Input(
            searchButtonDidTap: searchButtonDidTap.asObservable(),
            collectionViewDidScroll: collectionViewDidScroll.asObservable()
        )
        let output = viewModel.transform(input)
        
        configureSearchedApps(with: output.searchedApps)
        configureNextSearchedApps(with: output.nextSearchedApps)
    }
    
    private func configureSearchedApps(with searchedApps: Observable<[HashableApp]>) {
        searchedApps
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] apps in
                self?.configureSnapshot(with: apps)
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSnapshot(with apps: [HashableApp]) {
        snapshot = NSDiffableDataSourceSnapshot<SectionKind, HashableApp>()
        snapshot.appendSections([.main])
        snapshot.appendItems(apps)
        diffableDataSource.apply(snapshot)
    }
    
    private func configureNextSearchedApps(with nextSearchedApps: Observable<[HashableApp]>) {
        nextSearchedApps
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nextSearchedApps in
                self?.applySnapshot(with: nextSearchedApps)
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(with nextSearchedApps: [HashableApp]) {
        snapshot.appendItems(nextSearchedApps, toSection: .main)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - Namespaces
extension AppListViewController {
    
    private enum Content {
        static let searchBarPlaceHolder = "찾으시는 앱을 검색해주세요"
    }
    
}
