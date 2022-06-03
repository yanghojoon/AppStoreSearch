import UIKit
import RxCocoa

protocol ListCellDelegate: AnyObject {
    
    func countStar(from rating: Double) -> (empty: Int, fill: Int, half: Int)
    
}

class ListCell: UICollectionViewCell {
    
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
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.logoImageViewCornerRadius
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
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
        button.setTitle(Content.priceButtonTitle, for: .normal)
        button.backgroundColor = Design.priceButtonBackgroundColor
        button.setTitleColor(Design.priceButtonTitleColor, for: .normal)
        return button
    }()
    
    private var delegate: ListCellDelegate!
    private var viewModel = ListCellViewModel()
    
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
        logoImageURL: String,
        name: String,
        genre: String,
        averageUserRating: Double,
        userRatingCount: Int,
        formattedPrice: String
    ) {
        logoImageView.loadCachedImage(of: logoImageURL)
        nameLabel.text = name
        genreLabel.text = genre
        userRatingCountLabel.text = userRatingCount.omitDigit
        priceButton.setTitle(formattedPrice, for: .normal)
        createStarRating(from: averageUserRating)
    }
    
    private func configureUI() {
        delegate = viewModel
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(logoImageView)
        containerStackView.addArrangedSubview(descriptionStackView)
        containerStackView.addArrangedSubview(priceButton)
        
        descriptionStackView.addArrangedSubview(nameLabel)
        descriptionStackView.addArrangedSubview(genreLabel)
        descriptionStackView.addArrangedSubview(ratingStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            priceButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.2),
            nameLabel.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.3),
            genreLabel.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.5),
            ratingStackView.heightAnchor.constraint(equalTo: descriptionStackView.heightAnchor, multiplier: 0.2)
        ])
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
            
            imageView.tintColor = .systemGray
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
        
        static let logoImageViewCornerRadius: CGFloat = 15
        
        static let nameLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
        static let genreLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let userRatingCountLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let genreLabelTextColor: UIColor = .systemGray
        static let userRatingCountLabelTextColor: UIColor = .systemGray
        static let priceButtonBackgroundColor: UIColor = .systemGray
        static let priceButtonTitleColor: UIColor = .systemBlue
        
        static let emptyStarImage = UIImage(systemName: "star")
        static let starImage = UIImage(systemName: "star.fill")
        static let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")
    }
    
    private enum Content {
        static let priceButtonTitle = "무료"
    }
}
