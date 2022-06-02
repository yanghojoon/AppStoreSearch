import UIKit

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
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.logoImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
    
    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
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
    
    // MARK: - Initializers
    convenience init() {
        self.init()
        configureUI()
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        genreLabel.text = nil
        userRatingCountLabel.text = nil
        priceButton.setTitle(nil, for: .normal)
    }
    
    // MARK: - Methods
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(logoImageView)
        containerStackView.addArrangedSubview(descriptionStackView)
        containerStackView.addArrangedSubview(priceButton)
        
        descriptionStackView.addArrangedSubview(nameLabel)
        descriptionStackView.addArrangedSubview(genreLabel)
        descriptionStackView.addArrangedSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(starStackView)
        ratingStackView.addArrangedSubview(userRatingCountLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
}

// MARK: - Namespaces
extension ListCell {
    private enum Design {
        static let containerStackViewHorizontalInset: CGFloat = 10
        static let containerStackViewVerticalInset: CGFloat = 5
        
        static let logoImageViewCornerRadius: CGFloat = 5
        
        static let nameLabelFont: UIFont = .preferredFont(forTextStyle: .title2)
        static let genreLabelFont: UIFont = .preferredFont(forTextStyle: .body)
        static let userRatingCountLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let genreLabelTextColor: UIColor = .systemGray
        static let userRatingCountLabelTextColor: UIColor = .systemGray5
        static let priceButtonBackgroundColor: UIColor = .systemGray
        static let priceButtonTitleColor: UIColor = .systemBlue
    }
    
    private enum Content {
        static let priceButtonTitle = "무료"
    }
}
