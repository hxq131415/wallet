//
//  UIImageView+NTSDWebImageAdditions.swift
//  NTMember
//
//  Created by rttx on 2018/3/14.
//  Copyright © 2018年 MT. All rights reserved.
//

/** 基于OSS签名对SDWebImage的扩展
 ********************************************************
 * 因为需要进行图片地址签名，图片缓存框架使用的SDWebImage，而又需要
 * 避免OC调用Swift，故项目中的图片加载需要调用此类中的方法。
 ********************************************************
 */

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    //------------------------- 网络图片加载&缓存 ------------------
    // 根据URL加载图片
    func oss_ntSetImageWithURL(urlStr: String?) {
        
        if let url = urlStr , !url.isEmpty {
            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                self.nt_setImage(with: URL(string: url))
            }
            else if url.hasPrefix("//") {
                let urlStr = "https:" + url
                self.nt_setImage(with: URL(string: urlStr))
            }
            else {
                // 需要进行签名
            }
        }
        else {
            self.nt_setImage(with: nil)
        }
    }
    
    // 根据URL加载图片，带加载默认图
    func oss_ntSetImageWithURL(urlStr: String?, placeholderImage: UIImage?) {
        
        if let url = urlStr , !url.isEmpty {
            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                self.nt_setImage(with: URL(string: url), placeholderImage: placeholderImage)
            }
            else if url.hasPrefix("//") {
                let urlStr = "https:" + url
                self.nt_setImage(with: URL(string: urlStr))
            }
            else {
                // 需要进行签名
            }
        }
        else {
            self.nt_setImage(with: nil, placeholderImage: placeholderImage)
        }
    }
    
    func oss_ntSetImageWithURL(urlStr: String?, placeholderImage: UIImage?, completeBlock:@escaping (SDExternalCompletionBlock)) {
        
        if let url = urlStr , !url.isEmpty {
            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                self.nt_setImage(with: URL(string: url), placeholderImage: placeholderImage, completed: completeBlock)
            }
            else if url.hasPrefix("//") {
                let urlStr = "https:" + url
                self.nt_setImage(with: URL(string: urlStr))
            }
            else {
                // 需要进行签名
            }
        }
        else {
            self.nt_setImage(with: nil, placeholderImage: placeholderImage, completed: completeBlock)
        }
    }
    
    //------------------------- 网络图片加载&裁剪&缓存 --------------------
    // 根据尺寸裁剪图片<居中裁剪>
    func oss_ntAutoCutImageWithURL(urlStr: String?, targetSize: CGSize, placeholderImage: UIImage?, rectCorner: UIRectCorner? = nil, cornerRadius: CGFloat? = nil) {
        
        if let url = urlStr , !url.isEmpty {
            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                self.autoCutImage(with: targetSize, imageURL: URL(string: url), placeholderImage: placeholderImage, corner: rectCorner ?? .allCorners, cornerRadius: cornerRadius ?? 0)
            }
            else if url.hasPrefix("//") {
                let urlStr = "https:" + url
                self.nt_setImage(with: URL(string: urlStr))
            }
            else {
                // 需要进行签名
            }
        }
        else {
            self.autoCutImage(with: targetSize, imageURL: nil, placeholderImage: placeholderImage, corner: rectCorner ?? .allCorners, cornerRadius: cornerRadius ?? 0)
        }
    }
    
    // TODO: - 带边框裁剪，顶部裁剪，带背景色，边框颜色等裁剪，需要时再进行添加即可
    
}
