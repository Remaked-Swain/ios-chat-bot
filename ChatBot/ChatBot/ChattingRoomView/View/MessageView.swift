import UIKit

final class MessageView: UIView {
    private lazy var contentView: MessageContentView = {
        let contentView = MessageContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        return contentView
    }()
    
    private var bubbleLayer: CAShapeLayer
    
    private var role: Role? {
        didSet { setNeedsDisplay() }
    }
    
    init(configuration: MessageViewContentConfiguration) {
        bubbleLayer = CAShapeLayer()
        super.init(frame: .zero)
        layer.addSublayer(bubbleLayer)
        contentView.configuration = configuration
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 구현 안됨")
    }
}

// MARK: Configure MessageView Method
extension MessageView {
    func updateConfiguration(configuration: MessageViewContentConfiguration) {
        role = configuration.role
        contentView.configuration = configuration
    }
}

// MARK: Autolayout Methods
extension MessageView {
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

// MARK: Draw Methods
extension MessageView {
    override func draw(_ rect: CGRect) {
        if role == .user {
            drawRightBubble()
        } else if role == .assistant {
            drawLeftBubble()
        }
        
        super.draw(rect)
    }
    
    private func drawRightBubble() {
        let width = bounds.size.width
        let height = bounds.size.height
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.fill()
        
        bubbleLayer.fillColor = UIColor.systemBlue.cgColor
        bubbleLayer.path = bezierPath.cgPath
    }
    
    private func drawLeftBubble() {
        let width: CGFloat = max(80, bounds.size.width)
        let height: CGFloat = max(50, bounds.size.height)
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 22, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: width, y: 17))
        bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
        bezierPath.fill()
        
        bubbleLayer.fillColor = UIColor.systemOrange.cgColor
        bubbleLayer.path = bezierPath.cgPath
    }
}
