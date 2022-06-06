import UIKit

protocol TitleStackViewDelegate: AnyObject {
    
    func shareButtonDidTap()
    
}

final class TitleStackView: UIStackView {
    
    // MARK: - Properties
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.thumbnailImageViewCornerRadius
        imageView.layer.borderWidth = Design.thumbnailImageViewBorderWidth
        imageView.layer.borderColor = Design.thumbnailImageViewBorderColor
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
    
    weak var delegate: TitleStackViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func apply(thumnail: String, name: String, producer: String, price: String) {
        thumbnailImageView.loadCachedImage(of: thumnail)
        nameLabel.text = name
        producerLabel.text = producer
        priceButton.setTitle(price, for: .normal)
    }
    
    private func configureUI() {
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareButtonDidTap)))
        
        axis = .horizontal
        alignment = .fill
        distribution = .fill
        spacing = 10
        
        addArrangedSubview(thumbnailImageView)
        addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(nameLabel)
        titleDescriptionStackView.addArrangedSubview(producerLabel)
        titleDescriptionStackView.addArrangedSubview(titleButtonStackView)
        titleButtonStackView.addArrangedSubview(priceButton)
        titleButtonStackView.addArrangedSubview(shareButton)
        
        guard let buttonTitle = priceButton.titleLabel else { return }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),
            titleDescriptionStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            buttonTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            buttonTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            nameLabel.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.5),
            producerLabel.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.2),
            titleButtonStackView.heightAnchor.constraint(equalTo: titleDescriptionStackView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    @objc
    private func shareButtonDidTap() {
        delegate?.shareButtonDidTap()
    }
    
}

// MARK: - Namespace
extension TitleStackView {
    
    private enum Design {
        
        static let thumbnailImageViewCornerRadius: CGFloat = 15
        static let priceButtonCornerRadius: CGFloat = 15
        static let thumbnailImageViewBorderWidth: CGFloat = 2
        
        static let nameLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        static let producerLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let priceButtonTitleFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let thumbnailImageViewBorderColor: CGColor = UIColor.systemGray6.cgColor
        static let producerLabelTextColor: UIColor = .systemGray
        static let priceButtonTitleColor: UIColor = .systemBlue
        static let priceButtonBackgroundColor: UIColor = .systemGray6
        
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
        
    }
    
    enum Content {
        
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
        
    }
    
}
