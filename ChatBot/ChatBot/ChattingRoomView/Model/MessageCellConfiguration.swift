import UIKit

struct MessageCellContentConfiguration: UIContentConfiguration, Hashable {
    var text: String?
    var role: Role?
    
    func makeContentView() -> UIView & UIContentView {
        return MessageCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MessageCellContentConfiguration {
        return self
    }
}
