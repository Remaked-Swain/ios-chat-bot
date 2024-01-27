import UIKit

final class MessageCell: UICollectionViewCell {
    var message: Message? {
        didSet { setNeedsUpdateConfiguration() }
    }
}

// MARK: Configure Cell Methods
extension MessageCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        var configuration = MessageCellContentConfiguration().updated(for: state)
        configuration.text = message?.content
        configuration.role = message?.role
        contentConfiguration = configuration
    }
}
