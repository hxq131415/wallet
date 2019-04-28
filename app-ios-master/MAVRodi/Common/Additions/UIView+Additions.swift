//
//  UIView+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/8.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set(newValue) {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    func width() -> CGFloat {
        return self.bounds.width
    }
    
    func height() -> CGFloat {
        return self.bounds.height
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    /// 设置圆角
    func setCornerRadius(radius: CGFloat) {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    /// 设置圆角 mask方式
    func setCornerRadius(radius: CGFloat, corners: UIRectCorner, maskRect: CGRect?) {
        
        var maskRect_ = maskRect
        if maskRect_ == nil {
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
            maskRect_ = self.bounds
        }
        
        let maskPath = UIBezierPath(roundedRect: maskRect_!, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    // 设置边框
    func setBorderWithColor(borderColor: UIColor?, borderWidth: CGFloat) {
        
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    // 移除所有子视图
    func removeAllSubviews() {
        
        for subVw in self.subviews {
            subVw.removeFromSuperview()
        }
    }
    
    // 添加竖线
    func addvertialLineWithColor(color: UIColor, lineWidth: CGFloat, lineHeight: CGFloat, distanceToLeft: CGFloat = 0) {
        
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        let filterLayerList = self.layer.sublayers?.filter({ (subLayer) -> Bool in
            return subLayer.name == "right_verital_line_view"
        })
        
        filterLayerList?.first?.removeFromSuperlayer()
        
        let vertialLineLayer = CAShapeLayer()
        vertialLineLayer.name = "right_verital_line_view"
        vertialLineLayer.frame = CGRect(x: self.frame.size.width - lineWidth - distanceToLeft, y: (self.frame.size.height - lineHeight) * 0.5, width: lineWidth, height: lineHeight)
        vertialLineLayer.backgroundColor = color.cgColor
        self.layer.addSublayer(vertialLineLayer)
    }
    
    // 设置shadow
    func setShadowWithColor(shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float = 1.0, shadowPath: CGPath? = nil) {
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowPath = shadowPath
        self.layer.shadowOpacity = shadowOpacity
    }
    
    // MARK: - MBProgressHUD Addition
    // 显示提示信息在View中部
    func showHUDWithMessageToCenter(message: String, afterDelay: TimeInterval = 2.5) {
        
        let hud = MBProgressHUD(view: self)
        hud.animationType = .fade
        hud.mode = .text
        hud.areDefaultMotionEffectsEnabled = false
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        hud.contentColor = UIColor.white
        hud.label.text = message
        hud.label.textColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.margin = 10
        self.addSubview(hud)
        self.bringSubview(toFront: hud)
        
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
    @discardableResult
    func setGradient(colors: [UIColor], startPoint: CGPoint ,endPoint: CGPoint) -> CAGradientLayer {
        func setGradient(_ layer: CAGradientLayer) {
            self.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.bounds
            CATransaction.commit()
            
            layer.colors = colorArr
            layer.startPoint = startPoint
            layer.endPoint = endPoint
        }
        
        var gradientLayer = CAGradientLayer()
        self.layer.insertSublayer(gradientLayer , at: 0)
        setGradient(gradientLayer)
        objc_setAssociatedObject(self, &gradientLayer, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gradientLayer
    }
}
