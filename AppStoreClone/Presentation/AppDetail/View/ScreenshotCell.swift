import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let screenshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.clipsToBounds = true
        return imageView
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
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        screenshotImageView.image = nil
    }
    
    // MARK: - Methods
    func apply(
        screenshotURL: String
    ) {
        screenshotImageView.loadCachedImage(of: screenshotURL)
    }
    
    private func configureUI() {
        addSubview(screenshotImageView)

        NSLayoutConstraint.activate([
            screenshotImageView.topAnchor.constraint(equalTo: self.topAnchor),
            screenshotImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            screenshotImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            screenshotImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
