import UIKit

open class ACDrawerViewController: UIViewController {
    
    weak var delegate: ACDrawerViewControllerDelegate?
    
    private var topConstraint: NSLayoutConstraint!
    
    private var parentHeight: CGFloat = 0
    
    private var minimumHeight: CGFloat = 0
    private var maximumHeight: CGFloat = 0
    
    private var minimumHeightPercentage: CGFloat = 0
    private var maximumHeightPercentage: CGFloat = 0
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
    func add(toParent parent: UIViewController, minimum: CGFloat, maximum: CGFloat) {
        parentHeight = parent.view.frame.height
        
        minimumHeightPercentage = minimum
        maximumHeightPercentage = maximum
        
        minimumHeight = parentHeight * minimum
        maximumHeight = parentHeight * maximum
        
        parent.addChildViewController(self)
        
        let childView = view!
        let parentView = parent.view!
        
        parentView.addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        
        topConstraint = parentView.bottomAnchor.constraint(equalTo: childView.topAnchor, constant: 400)
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
        topConstraint.constant -= selector.translation(in: view).y
        selector.setTranslation(.zero, in: view)
    }
}

private extension ACDrawerViewController {
    func style() {
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.masksToBounds = true
    }
}

private extension ACDrawerViewController {
    
}

private extension ACDrawerViewController {
    
}
