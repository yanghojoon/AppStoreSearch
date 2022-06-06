import UIKit

protocol ListCellDelegate: AnyObject {
    
    func countStar(from rating: Double) -> (empty: Int, fill: Int, half: Int)
    
}

final class ListCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.containerStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.thumbnailImageViewCornerRadius
        imageView.layer.borderWidth = Design.thumbnailImageViewBorderWidth
        imageView.layer.borderColor = Design.thumbnailImageViewBorderColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.nameLabelFont
        return label
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.genreLabelFont
        label.textColor = Design.genreLabelTextColor
        return label
    }()
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let userRatingCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Design.userRatingCountLabelFont
        label.textColor = Design.userRatingCountLabelTextColor
        return label
    }()
    private let priceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Design.priceButtonTitleColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        button.titleLabel?.backgroundColor = Design.priceButtonBackgroundColor
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.layer.cornerRadius = Design.priceButtonCornerRadius
        button.titleLabel?.clipsToBounds = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private(set) var app: App?
    private var delegate: ListCellDelegate!
    private var viewModel: ListCellViewModel!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        genreLabel.text = nil
        userRatingCountLabel.text = nil
        priceButton.setTitle(nil, for: .normal)
        ratingStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Methods
    func apply(
        viewModel: ListCellViewModel,
        app: App
    ) {
        setupViewModel(viewModel: viewModel)
        thumbnailImageView.loadCachedImage(of: app.artworkUrl100)
        nameLabel.text = app.trackName
        genreLabel.text = app.primaryGenreName
        userRatingCountLabel.text = app.userRatingCount.omitDigit
        priceButton.setTitle(app.formattedPrice, for: .normal)
        createStarRating(from: app.averageUserRating)
        self.app = app
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(thumbnailImageView)
        containerStackView.addArrangedSubview(descriptionStackView)
        containerStackView.addArrangedSubview(priceButton)
        
        descriptionStackView.addArrangedSubview(nameLabel)
        descriptionStackView.addArrangedSubview(genreLabel)
        descriptionStackView.addArrangedSubview(ratingStackView)
        
        guard let buttonTitle = priceButton.titleLabel else { return }
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),
            priceButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.2),
            buttonTitle.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.15),
            buttonTitle.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.3),
            nameLabel.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.4),
            genreLabel.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.4),
            ratingStackView.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupViewModel(viewModel: ListCellViewModel) {
        self.viewModel = viewModel
        delegate = viewModel
    }
    
    private func createStarRating(from rating: Double) {
        let starCount = delegate.countStar(from: rating)
        
        drawStar(of: starCount.fill, image: Design.starImage)
        drawStar(of: starCount.half, image: Design.halfStarImage)
        drawStar(of: starCount.empty, image: Design.emptyStarImage)
        ratingStackView.addArrangedSubview(userRatingCountLabel)
    }
    
    private func drawStar(of count: Int, image: UIImage?) {
        for _ in 0..<count {
            let imageView = UIImageView()
            
            ratingStackView.addArrangedSubview(imageView)
            
            imageView.tintColor = Design.starImageViewTintColor
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            imageView.image = image
        }
    }
    
}

// MARK: - Namespaces
extension ListCell {
    private enum Design {
        static let containerStackViewHorizontalInset: CGFloat = 10
        static let containerStackViewVerticalInset: CGFloat = 15
        static let containerStackViewSpacing: CGFloat = 10
        
        static let thumbnailImageViewCornerRadius: CGFloat = 15
        static let thumbnailImageViewBorderWidth: CGFloat = 2
        static let thumbnailImageViewBorderColor = UIColor.systemGray6.cgColor
        
        static let nameLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
        static let genreLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let userRatingCountLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let genreLabelTextColor: UIColor = .systemGray
        static let userRatingCountLabelTextColor: UIColor = .systemGray
        static let priceButtonTitleColor: UIColor = .systemBlue
        
        static let emptyStarImage = UIImage(systemName: "star")
        static let starImage = UIImage(systemName: "star.fill")
        static let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")
        
        static let priceButtonCornerRadius: CGFloat = 10
        static let priceButtonBackgroundColor: UIColor = .systemGray6
        static let starImageViewTintColor: UIColor = .systemGray
    }
}
