import UIKit
import RxSwift

final class AppDetailViewController: UIViewController {
    
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
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let titleStackView = TitleStackView(frame: .zero)
    private var viewModel: AppDetailViewModel!
    private let viewDidLoadDidInvoke = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: AppDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewDidLoadDidInvoke.onNext(())
    }
    
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor)
        ])
    }
    
}

// MARK: - Rx Binding Methods
extension AppDetailViewController {
    
    private func bind() {
        let input = AppDetailViewModel.Input(viewDidLoadDidInvoke: viewDidLoadDidInvoke.asObservable())
        let output = viewModel.transform(input)
        
        configureAppItems(with: output.appItems)
    }
    
    private func configureAppItems(with appItems: Observable<App>) {
        appItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] app in
                self?.titleStackView.setup(
                    thumnail: app.artworkUrl100,
                    name: app.trackName,
                    producer: app.artistName,
                    price: app.formattedPrice
                )
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Namespaces
extension AppDetailViewController {
    
    private enum Design {
        
        static let containerStackViewHorizontalInset: CGFloat = 15
        static let containerStackViewVerticalInset: CGFloat = 15

    }
    
}
