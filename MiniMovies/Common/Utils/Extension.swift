//
//  Extension.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import UIKit

public extension UIView {
    // MARK: - NIB
    static func nibName() -> String {
        let nameSpaceClassName = NSStringFromClass(self)
        guard let className = nameSpaceClassName.components(separatedBy: ".").last else { return nameSpaceClassName }
        
        return className
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.nibName(), bundle: Bundle(for: self))
    }
    
    func roundedCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIApplication {
    public class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

public extension UITableViewCell {
    
    // MARK: - Reuse identifer
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension UIButton {
    public struct AssociatedKeys {
        static var ActionKey = "actionKey"
    }
    
    // Closure typealias for button action
    public typealias ButtonAction = () -> Void
    
    // Property to store the closure
    private var action: ButtonAction? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ButtonAction
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Method to set the action closure
    public func addAction(_ action: ButtonAction?) {
        self.action = action
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    // Selector method that invokes the action closure
    @objc private func handleAction() {
        action?()
    }
}

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func convertToYear() -> String? {
        guard let date = convertToDate() else { return nil }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return String(year)
    }
    
    func convertToRelativeTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            let now = Date()
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
            return formatter.string(from: date, to: now)?.appending(" ago")
        }
        return nil
    }
}

extension Int {
    func convertToFormattedTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = [.pad]
        
        let interval = TimeInterval(self * 60)
        return formatter.string(from: interval) ?? ""
    }
}
