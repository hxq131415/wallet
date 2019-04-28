//
//  LGDrawLine+UIView.swift
//  iPhoneXDemo
//
//  Created by rttx on 2018/4/19.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

enum DrawLinePosition: Int {
    case top        = 0
    case bottom     = 1
    case left       = 2
    case right      = 3
    case horizontally   = 4
    case vertical       = 5
}

let drawLineWidth:CGFloat = 0.5

extension UIView {
    
    /**
     *  绘制直线
     *
     *  color 绘制线颜色
     *  position 绘制线方向
     */
    func drawLine(color: UIColor = UIColor.lightGray, position:DrawLinePosition = .top) {
        
        let path = UIBezierPath()
        var startPoint:CGPoint?
        var endPoint:CGPoint?
        
        let drawLine_position = "\(position.rawValue)"
        if position == .top {
            
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: self.frame.width, y: 0)
        }else if position == .bottom {
            
            startPoint = CGPoint(x: 0, y: self.frame.height)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        }else if position == .left {
            
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: self.frame.height)
        }else if position == .right {
            
            startPoint = CGPoint(x: self.frame.width, y: 0)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        }else if position == .horizontally {
            
            startPoint = CGPoint(x: self.frame.width / 2, y: 0)
            endPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        }else if position == .vertical {
            
            startPoint = CGPoint(x: 0, y: self.frame.height / 2)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        }
        
        if let startPoint_ = startPoint {
           path.move(to: startPoint_)
        }
        if let endPoint_ = endPoint {
            path.addLine(to: endPoint_)
        }
        
        let lineLayer = self.layer.sublayers?.filter({ (subLayer) -> Bool in
            return subLayer.name == "drawLine_name_layer" + drawLine_position
        })
        if let layerArr = lineLayer,
            layerArr.count > 0 {
            layerArr.first?.removeFromSuperlayer()
        }
        
        let layer = CAShapeLayer()
        layer.name = "drawLine_name_layer" + drawLine_position
        layer.frame = self.bounds
        layer.lineWidth = drawLineWidth
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }
    /**
     *  绘制虚线
     *
     *  color 绘制线颜色
     *  position 绘制线方向
     */
    func drawBrokenLine(color: UIColor = UIColor.lightGray, position:DrawLinePosition) {
        
        let path = UIBezierPath()
        var startPoint:CGPoint?
        var endPoint:CGPoint?
        
        if position == .top {
            
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: self.frame.width, y: 0)
        }else if position == .bottom {
            
            startPoint = CGPoint(x: 0, y: self.frame.height)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        }else if position == .left {
            
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: self.frame.height)
        }else if position == .right {
            
            startPoint = CGPoint(x: self.frame.width, y: 0)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        }else if position == .horizontally {
            
            startPoint = CGPoint(x: self.frame.width / 2, y: 0)
            endPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        }else if position == .vertical {
            
            startPoint = CGPoint(x: 0, y: self.frame.height / 2)
            endPoint = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        }
        
        if let startPoint_ = startPoint {
            path.move(to: startPoint_)
        }
        if let endPoint_ = endPoint {
            path.addLine(to: endPoint_)
        }
        
        let lineLayer = self.layer.sublayers?.filter({ (subLayer) -> Bool in
            return subLayer.name == "drawBrokenLine_name_layer"
        })
        if let layerArr = lineLayer,
            layerArr.count > 0 {
            layerArr.first?.removeFromSuperlayer()
        }
        
        let layer = CAShapeLayer()
        layer.name = "drawBrokenLine_name_layer"
        layer.frame = self.bounds
        layer.lineDashPattern = [5,2]
        layer.lineWidth = drawLineWidth
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }
}
