import UIKit

final class SummaryScrollView: UIScrollView {
    
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let ratingContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let advisoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let advisoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let advisoryContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let developerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let developerTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let developerContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let categoryContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let languageTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let languageContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func apply(with app: App) {
        guard let language = app.languageCodesISO2A.first else { return }
        ratingTitleLabel.text = "\(app.userRatingCount.omitDigit)개의 평가"
        ratingContentLabel.text = "\(round(app.averageUserRating * 10) / 10)"
        advisoryTitleLabel.text = "사용연령"
        advisoryContentLabel.text = "\(app.contentAdvisoryRating)"
        developerTitleLabel.text = "개발자"
        developerContentLabel.text = app.artistName
        categoryTitleLabel.text = "카테고리"
        categoryContentLabel.text = app.primaryGenreName
        languageTitleLabel.text = "\(app.languageCodesISO2A.count)개의 언어"
        languageContentLabel.text = language
    }
    
    private func configureUI() {
        self.showsHorizontalScrollIndicator = false
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(ratingStackView)
        containerStackView.addArrangedSubview(advisoryStackView)
        containerStackView.addArrangedSubview(developerStackView)
        containerStackView.addArrangedSubview(categoryStackView)
        containerStackView.addArrangedSubview(languageStackView)
        
        ratingStackView.addArrangedSubview(ratingTitleLabel)
        ratingStackView.addArrangedSubview(ratingContentLabel)
        advisoryStackView.addArrangedSubview(advisoryTitleLabel)
        advisoryStackView.addArrangedSubview(advisoryContentLabel)
        developerStackView.addArrangedSubview(developerTitleLabel)
        developerStackView.addArrangedSubview(developerContentLabel)
        categoryStackView.addArrangedSubview(categoryTitleLabel)
        categoryStackView.addArrangedSubview(categoryContentLabel)
        languageStackView.addArrangedSubview(languageTitleLabel)
        languageStackView.addArrangedSubview(languageContentLabel)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ratingStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.25)
        ])
    }
    
}

extension SummaryScrollView {
    
    private enum Design {
        
        static let containerStackViewHorizontalInset: CGFloat = 15
        static let containerStackViewVerticalInset: CGFloat = 15
        static let contentStackViewSpacing: CGFloat = 10
        
        static let contentLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        static let titleLabelColor: UIColor = .systemGray
        static let contentLabelColor: UIColor = .systemGray

    }
    
}

