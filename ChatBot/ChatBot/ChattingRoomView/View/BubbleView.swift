import UIKit

final class BubbleView: UIView {
    private var bubbleLayer: CAShapeLayer
    private var dotLayer: CAReplicatorLayer
    
    private let bubbleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var text: String? {
        didSet { bubbleLabel.text = text }
    }
    
    var role: Role? {
        didSet { setNeedsDisplay() }
    }
    
    init() {
        bubbleLayer = CAShapeLayer()
        dotLayer = CAReplicatorLayer()
        super.init(frame: .zero)
        
        layer.addSublayer(bubbleLayer)
        layer.addSublayer(dotLayer)
        
        addSubview(bubbleLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            bubbleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bubbleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bubbleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bubbleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        
        if role == .user {
            dotLayer.isHidden = true
            drawBubbleToRight()
        } else if role == .assistant {
            drawBubbleToLeft()
            
            if text == "      " {
                showAnimatingDotsInImageView(dotXOffset: 6.0, dotSize: 4.0, dotSpacing: 8.0)
            }
        }
        
        super.draw(rect)
    }
    
    private func showAnimatingDotsInImageView(dotXOffset: CGFloat, dotSize: CGFloat, dotSpacing: CGFloat) {
        let lay = CAReplicatorLayer()
        let bar = CALayer()
        
        dotLayer.addSublayer(lay)
        bar.frame = CGRect(x: bounds.width / 2 - dotXOffset, y: bounds.height / 2, width: dotSize, height: dotSize)
        
        bar.cornerRadius = bar.frame.width / 2  
        bar.backgroundColor = UIColor.black.cgColor
        lay.addSublayer(bar)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        bar.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
    }
    
    private func drawBubbleToRight() {
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
    
    private func drawBubbleToLeft() {
        let width = bounds.size.width
        let height = bounds.size.height
        
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