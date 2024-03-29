import UIKit

open class ACDrawerViewController: UIViewController {
    
    public var animationDuration: TimeInterval = 0.3
    public var animationDelay: TimeInterval = 0
    public var animationSpringDamping: CGFloat = 0.75
    public var animationInitialSpringVelocity: CGFloat = 0
    public var animationOptions: UIView.AnimationOptions = [.curveEaseInOut]
    
    weak var delegate: ACDrawerViewControllerDelegate?
    
    private var topConstraint: NSLayoutConstraint!
    
    private var parentHeight: CGFloat = 0
    
    private var minimumHeight: CGFloat = 0
    private var maximumHeight: CGFloat = 0
    private var heightDelta: CGFloat = 0
    
    private var minimumHeightPercentage: CGFloat = 0
    private var maximumHeightPercentage: CGFloat = 0
    private var heightPercentageDelta: CGFloat = 0
    
    private var minimumOpacity: CGFloat = 0
    private var maximumOpacity: CGFloat = 0
    private var opacityDelta: CGFloat = 0
}

// MARK: - Lifecyle Events

extension ACDrawerViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        style()
    }
}

// MARK: - Public Methods

public extension ACDrawerViewController {
    func add(toParent parent: UIViewController,
             height: (minimum: CGFloat, maximum: CGFloat),
             opacity: ((minimum: CGFloat, maximum: CGFloat))) {
        
        parentHeight = parent.view.frame.height
        
        minimumHeightPercentage = height.minimum
        maximumHeightPercentage = height.maximum
        heightPercentageDelta = maximumHeightPercentage - minimumHeightPercentage
        
        minimumHeight = parentHeight * minimumHeightPercentage
        maximumHeight = parentHeight * maximumHeightPercentage
        heightDelta = maximumHeight - minimumHeight
        
        minimumOpacity = opacity.minimum
        maximumOpacity = opacity.maximum
        opacityDelta = maximumOpacity - minimumOpacity
        
        parent.addChildViewController(self)
        
        let childView = view!
        let parentView = parent.view!
        
        parentView.addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        
        topConstraint = parentView.bottomAnchor.constraint(equalTo: childView.topAnchor, constant: minimumHeight)
        topConstraint.isActive = true
        
        didMove(toParentViewController: self)
    }
}

// MARK: - Set Up Methods

private extension ACDrawerViewController {
    func addGestureRecognizers() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanView)))
    }
}

// MARK: - Objective-C Methods

private extension ACDrawerViewController {
    @objc func didPanView(_ selector: UIPanGestureRecognizer) {
        switch selector.state {
        case .ended:
            let verticalVelocity = selector.velocity(in: view).y
            let isExpanding = verticalVelocity < 0
            
            animate(topConstraint, to: isExpanding ? maximumHeight : minimumHeight, with: verticalVelocity)
            
        default:
            let newHeight = requestedHeight(from: selector)
            
            update(topConstraint, to: newHeight)
            update(parent!, for: newHeight)
            
            selector.setTranslation(.zero, in: view)
            
        }
    }
}

private extension ACDrawerViewController {
    func requestedHeight(from gesture: UIPanGestureRecognizer) -> CGFloat {
        let requestedHeight = topConstraint.constant - gesture.translation(in: view).y
        
        if requestedHeight <= minimumHeight {
            return minimumHeight
        } else if requestedHeight >= maximumHeight {
           return maximumHeight
        } else {
            return requestedHeight
        }
    }
}

private extension ACDrawerViewController {
    func update(_ constraint: NSLayoutConstraint, to newHeight: CGFloat) {
        constraint.constant = newHeight
    }
    
    func update(_ parent: UIViewController, for newHeight: CGFloat) {
        
    }
}

private extension ACDrawerViewController {
    func animate(_ constraint: NSLayoutConstraint, to newHeight: CGFloat, with velocity: CGFloat) {
        constraint.constant = newHeight
        UIView.animate(withDuration: animationDuration,
                       delay: animationDelay,
                       usingSpringWithDamping: animationSpringDamping,
                       initialSpringVelocity: animationInitialSpringVelocity,
                       options: animationOptions,
                       animations: parent!.view.layoutIfNeeded,
                       completion: nil)
    }
}

private extension ACDrawerViewController {
    func style() {
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.masksToBounds = true
    }
}
