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
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.thumbnailImageViewCornerRadius
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.nameLabelFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let producerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.producerLabelFont
        label.textColor = Design.producerLabelTextColor
        return label
    }()
    private let titleButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let priceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Design.priceButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.priceButtonTitleFont
        button.titleLabel?.backgroundColor = Design.priceButtonBackgroundColor
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.layer.cornerRadius = Design.priceButtonCornerRadius
        button.titleLabel?.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.contentVerticalAlignment = .bottom
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(Content.shareButtonImage, for: .normal)
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
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
        
        titleStackView.addArrangedSubview(thumbnailImageView)
        titleStackView.addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(nameLabel)
        titleDescriptionStackView.addArrangedSubview(producerLabel)
        titleDescriptionStackView.addArrangedSubview(titleButtonStackView)
        titleButtonStackView.addArrangedSubview(priceButton)
        titleButtonStackView.addArrangedSubview(shareButton)
        
        guard let buttonTitle = priceButton.titleLabel else { return }
        
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
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),
            titleDescriptionStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.6),
            buttonTitle.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.15),
            buttonTitle.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.2),
            nameLabel.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.5),
            producerLabel.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.1),
            titleButtonStackView.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.4)
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
                self?.setupTitleStackView(
                    thumnail: app.artworkUrl100,
                    name: app.trackName,
                    producer: app.artistName,
                    price: app.formattedPrice
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitleStackView(thumnail: String, name: String, producer: String, price: String) {
        thumbnailImageView.loadCachedImage(of: thumnail)
        nameLabel.text = name
        producerLabel.text = producer
        priceButton.setTitle(price, for: .normal)
    }
    
}

// MARK: - Namespaces
extension AppDetailViewController {
    
    private enum Design {
        
        static let containerStackViewHorizontalInset: CGFloat = 15
        static let containerStackViewVerticalInset: CGFloat = 15
        static let thumbnailImageViewCornerRadius: CGFloat = 15
        static let priceButtonCornerRadius: CGFloat = 15
        
        static let nameLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let producerLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let priceButtonTitleFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let producerLabelTextColor: UIColor = .systemGray
        static let priceButtonTitleColor: UIColor = .systemBlue
        static let priceButtonBackgroundColor: UIColor = .systemGray6
        
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
        
    }
    
    enum Content {
        
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
        
    }
    
}
