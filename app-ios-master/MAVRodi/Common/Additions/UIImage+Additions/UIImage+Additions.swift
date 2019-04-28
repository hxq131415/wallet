//
//  Additions.swift
//  NTMember
//
//  Created by rttx on 2018/1/30.
//  Copyright © 2018年 MT. All rights reserved.
//

import UIKit
import EFQRCode

extension UIImage {
    
    //旋转图片
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * Double.pi / 180.0));
        bitmap?.rotate(by: CGFloat(Double.pi));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
    
    static func defaultHeadImage() -> UIImage {
        return UIImage(named: "image_default_head")!.withRenderingMode(.alwaysOriginal)
    }
    
    ///图片合成
    static func imageSynthesis(bgImage:UIImage, image:UIImage, imageRect:CGRect) -> UIImage? {
        
        let size = bgImage.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        bgImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
        image.draw(in: imageRect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    /// 生成二维码
    static func creatQrCodeImage(content:String) -> UIImage? {
        
        let generator = EFQRCodeGenerator(content: content, size: EFIntSize(width: 500, height: 500))
        generator.setInputCorrectionLevel(inputCorrectionLevel: EFInputCorrectionLevel.h)
        generator.setColors(backgroundColor: CIColor(color: UIColor.white), foregroundColor: CIColor(color: UIColor.black))
        
        if let qrImage = generator.generate() {
            return UIImage(cgImage: qrImage)
        }else {
            TELog(message: "生成二维码出错")
            return nil
        }
    }
}
