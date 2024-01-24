import UIKit

final class MessageCellContentView: UIView, UIContentView {
    private enum Constants {
        static let labelWidthRatio: CGFloat = 2/3
    }
    
    private lazy var messageView: MessageView = {
        let messageView = MessageView(configuration: MessageViewContentConfiguration())
        addSubview(messageView)
        messageView.backgroundColor = .clear
        messageView.translatesAutoresizingMaskIntoConstraints = false
        return messageView
    }()

    private var appliedConfiguration: MessageCellContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageCellContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    init(configuration: MessageCellContentConfiguration) {
        super.init(frame: .zero)
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor)
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
}

// MARK: Configuration
extension MessageCellContentView {
    private func apply(configuration: MessageCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        setUpConstraintsByRole()
        updateMessageViewConfiguration(configuration: configuration)
    }
    
    private func updateMessageViewConfiguration(configuration: MessageCellContentConfiguration) {
        var messageViewConfiguration = MessageViewContentConfiguration()
        messageViewConfiguration.text = configuration.text
        messageViewConfiguration.role = configuration.role
        messageView.updateConfiguration(configuration: messageViewConfiguration)
    }
}

// MARK: Autolayout Methods
extension MessageCellContentView {
    private func setUpConstraintsByRole() {
        let labelWidthRatio = Constants.labelWidthRatio
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            messageView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio)
        ])
        
        if appliedConfiguration.role == .user {
            leadingConstraint?.isActive = false
            trailingConstraint?.isActive = true
        } else {
            leadingConstraint?.isActive = true
            trailingConstraint?.isActive = false
        }
    }
}
