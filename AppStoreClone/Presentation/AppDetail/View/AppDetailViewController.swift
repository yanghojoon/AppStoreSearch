import UIKit
import RxSwift
import RxCocoa

final class AppDetailViewController: UIViewController {
    
    // MARK: - Nested Types
    private enum ScreenshotSectionKind: Int {
        
        case main
        
    }
    
    // MARK: - Properties
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 5
        return stackView
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width - Design.containerStackViewHorizontalInset * 2
        ).isActive = true
        view.setContentHuggingPriority(.required, for: .vertical)
        view.backgroundColor = .systemGray4
        return view
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = Design.descriptionTextViewFont
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .left
        textView.dataDetectorTypes = .all
        textView.textContainer.maximumNumberOfLines = 2
        return textView
    }()
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        return button
    }()
    
    private let titleStackView = TitleStackView(frame: .zero)
    private let summaryScrollView = SummaryScrollView(frame: .zero)
    private var screenshotCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    private var diffableDataSource: UICollectionViewDiffableDataSource<ScreenshotSectionKind, String>!
    private var snapshot: NSDiffableDataSourceSnapshot<ScreenshotSectionKind, String>!
    private let shareButtonDidtap = PublishSubject<Void>()
    private var viewModel: AppDetailViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: AppDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        bind()
    }
    
    // MARK: - Methods
    private func configureUI() {
        titleStackView.delegate = self
        
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(summaryScrollView)
        containerStackView.addArrangedSubview(separatorView)
        containerStackView.addArrangedSubview(screenshotCollectionView)
        containerStackView.addArrangedSubview(descriptionTextView)
        containerStackView.addArrangedSubview(moreButton)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            screenshotCollectionView.heightAnchor.constraint(equalTo: screenshotCollectionView.widthAnchor, multiplier: 1.15)
        ])
    }
    
    private func configureCollectionView() {
        screenshotCollectionView.isScrollEnabled = false
        screenshotCollectionView.register(cellClass: ScreenshotCell.self)
        screenshotCollectionView.collectionViewLayout = createCollectionViewLayout()
        screenshotCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
        return layout
    }
    
}

// MARK: - Rx Binding Methods
extension AppDetailViewController {
    
    private func bind() {
        let input = AppDetailViewModel.Input(
            moreButtonDidTap: moreButton.rx.tap.asObservable(),
            sharebuttonDidTap: shareButtonDidtap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureAppItems(with: output.items)
        configureShowMoreContent(with: output.showMoreContent)
        configureShowActivityViewController(with: output.showActivityViewController)
    }
    
    private func configureAppItems(with appItems: Observable<App>) {
        appItems
            .observe(on: MainScheduler.instance)
            .flatMap { [weak self] app -> Observable<[String]> in
                self?.titleStackView.apply(
                    thumnail: app.artworkUrl100,
                    name: app.trackName,
                    producer: app.artistName,
                    price: app.formattedPrice
                )
                self?.summaryScrollView.apply(with: app)
                self?.descriptionTextView.text = app.description
                
                return Observable.just(app.screenshotUrls)
            }
            .bind(to: screenshotCollectionView.rx.items(
                cellIdentifier: String(describing: ScreenshotCell.self),
                cellType: ScreenshotCell.self
            )) { row, item, cell in
                cell.apply(screenshotURL: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureScreenshot(with urls: Observable<[String]>) {
        urls
            .bind(to: screenshotCollectionView.rx.items(
                cellIdentifier: String(describing: ScreenshotCell.self),
                cellType: ScreenshotCell.self
            )) { row, item, cell in
                cell.apply(screenshotURL: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureShowMoreContent(with showMoreContent: Observable<Void>) {
        showMoreContent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.moreButton.isHidden = true
                self?.descriptionTextView.textContainer.maximumNumberOfLines = 0
                self?.descriptionTextView.invalidateIntrinsicContentSize()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureShowActivityViewController(with trackViewURL: Observable<String>) {
        trackViewURL
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                let items = [ShareAppActivityItemSouce(content: url)]
                
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - TitleStackView Delegate
extension AppDetailViewController: TitleStackViewDelegate {
    
    func shareButtonDidTap() {
        shareButtonDidtap.onNext(())
    }
    
}

// MARK: - Namespaces
extension AppDetailViewController {
    
    private enum Design {
        
        static let containerStackViewHorizontalInset: CGFloat = 15
        static let containerStackViewVerticalInset: CGFloat = 15
        
        static let descriptionTextViewFont: UIFont = .preferredFont(forTextStyle: .body)

    }
    
}
