import UIKit

struct MessageViewContentConfiguration: UIContentConfiguration, Hashable {
    var text: String?
    var role: Role?
    
    func makeContentView() -> UIView & UIContentView {
        return MessageContentView()
    }
    
    func updated(for state: UIConfigurationState) -> MessageViewContentConfiguration {
        return self
    }
}
