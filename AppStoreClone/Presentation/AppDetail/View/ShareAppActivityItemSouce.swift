import UIKit

final class ShareAppActivityItemSouce: NSObject, UIActivityItemSource {
    
    // MARK: - Properties
    private var content: String
    
    // MARK: - Initializers
    init(content: String) {
        self.content = content
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        content
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        content
    }
    
    
}
