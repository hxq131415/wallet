//
//  InvitationQRCodeView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
/**
 * 邀请二维码
 */

import UIKit
import EFQRCode

class InvitationQRCodeView: UIView {
    
    private var backgroundView: UIView = {
        return UIView(frame: CGRect.zero)
    }()
    
    private var qrCodeImageView: UIImageView = {
        return UIImageView(frame: CGRect.zero)
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setNeedsDisplay()
    }
    
    func subViewInitlzation() {
        
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(0)
            make.right.bottom.equalToSuperview().offset(0)
        }
        
        self.backgroundView.backgroundColor = UIColor.white
        
        self.backgroundView.addSubview(self.qrCodeImageView)
        self.qrCodeImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(5)
            make.right.bottom.equalToSuperview().offset(-5)
        }
        
        if let qrCodeImg = EFQRCode.generate(content: "", backgroundColor: UIColor.white.cgColor, foregroundColor: UIColorFromRGB(hexRGB: 0x424242).cgColor, watermark: nil) {
            self.qrCodeImageView.image = UIImage(cgImage: qrCodeImg)
        }
    }
    
    func configQRCodeContent(content: String) {
        
        if let qrCodeImg = EFQRCode.generate(content: content, backgroundColor: UIColor.white.cgColor, foregroundColor: UIColorFromRGB(hexRGB: 0x424242).cgColor, watermark: nil) {
            self.qrCodeImageView.image = UIImage(cgImage: qrCodeImg)
        }
    }
    
    // 画拐角
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        let size = self.bounds.size
//        
//        if let context = UIGraphicsGetCurrentContext() {
//            
//            context.setLineCap(CGLineCap.square)
//            context.setLineJoin(CGLineJoin.bevel)
//            context.setLineWidth(2)
//            context.setStrokeColor(UIColorFromRGB(hexRGB: 0x365ad8).cgColor)
//            
//            // 左拐角
//            context.move(to: CGPoint(x: 20, y: 0))
//            context.addLine(to: CGPoint(x: 0, y: 0))
//            context.addLine(to: CGPoint(x: 0, y: 20))
//            
//            context.move(to: CGPoint(x: 0, y: size.height - 20))
//            context.addLine(to: CGPoint(x: 0, y: size.height))
//            context.addLine(to: CGPoint(x: 20, y: size.height))
//            
//            // 右拐角
//            context.move(to: CGPoint(x: size.width - 20, y: size.height))
//            context.addLine(to: CGPoint(x: size.width, y: size.height))
//            context.addLine(to: CGPoint(x: size.width, y: size.height - 20))
//            
//            context.move(to: CGPoint(x: size.width - 20, y: 0))
//            context.addLine(to: CGPoint(x: size.width, y: 0))
//            context.addLine(to: CGPoint(x: size.width, y: 20))
//            
//            // 设置scale
//            context.scaleBy(x: UIScreen.main.scale, y: UIScreen.main.scale)
//            context.drawPath(using: CGPathDrawingMode.stroke)
//            
//        }
//        
//        
//    }
    
    
    
    
}
