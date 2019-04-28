//
//  TENullView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/15.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

private let kNullDataViewTag: Int = 291829

typealias TENullViewButtonAction = (() -> ())

class TENullView: UIView {

    private var iconImgView:UIImageView = UIImageView()
    var textLabel:UILabel = UILabel()
    private var button:UIButton = UIButton(type: .custom)
    
    var buttonAction: TENullViewButtonAction?
    
    var iconImgTop:CGFloat = 97 * theScaleToiPhone_6
    var textLabelTop:CGFloat = 47 * theScaleToiPhone_6
    var buttonTop:CGFloat = 56 * theScaleToiPhone_6
    
    var textColor:UIColor = UIColorFromRGB(hexRGB: 0x333333) {
        didSet{
            textLabel.textColor = textColor
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
 
    func initSetup(imageName:String?, text:String?, title:String?) {
        
        if let imageName_ = imageName {
            iconImgView.image = UIImage(named: imageName_)
        }
        
        if let text_ = text {
            textLabel.text = text_
        }
        
        if let title_ = title {
            button.setTitle(title_, for: .normal)
            button.isHidden = false
        }else {
            button.isHidden = true
        }
    }
    
    //更新UI  iconImgTop textLabelTop buttonTop
    func updateUI() {
        
        self.setNeedsLayout()
        
        iconImgView.snp.remakeConstraints() { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgTop)
        }
        
        textLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(iconImgView.snp.bottom).offset(textLabelTop)
        }
        
        button.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(buttonTop)
            make.width.equalTo(198 * theScaleToiPhone_6)
            make.height.equalTo(44 * theScaleToiPhone_6)
        }
        
        self.layoutIfNeeded()
    }
    
    func initUI() {
        
        iconImgView.contentMode = .scaleAspectFit
        self.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(iconImgTop)
        }
        
        textLabel.textColor = textColor
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp.bottom).offset(textLabelTop)
        }
        
        button = buttonWithFrame(frame: .zero, imageName: nil, selectedImageName: nil, buttonTitle: "", titleColor: UIColor.white, titleFont: UIFont.systemFont(ofSize: 14), addTarget: self, action: #selector(buttonAction(btn:)))
        button.backgroundColor = MRColorManager.RedTextColor
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(buttonTop)
            make.width.equalTo(198 * theScaleToiPhone_6)
            make.height.equalTo(44 * theScaleToiPhone_6)
        }
    }
    
    @objc func buttonAction(btn: UIButton) {
        
        if buttonAction != nil {
            buttonAction!()
        }
    }
    
    @discardableResult
    static func showNullDataViewToView(superVw: UIView, belowView: UIView? = nil, imageName: String?, text: String?, buttonTitle: String?, backgroundColor: UIColor? = MRColorManager.Table_Collection_ViewBackgroundColor,buttonTapClosure: TENullViewButtonAction? = nil) -> TENullView {
        
        if let nullView = superVw.viewWithTag(kNullDataViewTag) as? TENullView {
            nullView.removeFromSuperview()
        }
        
        let nullView = TENullView(frame: CGRect.zero)
        nullView.tag = kNullDataViewTag
        nullView.backgroundColor = backgroundColor
        nullView.iconImgTop = 190 * theScaleToiPhone_6
        nullView.textLabelTop = 16 * theScaleToiPhone_6
        nullView.textColor = MRColorManager.LightGrayTextColor
        if let title = buttonTitle,
            !title.isEmpty {
            nullView.initSetup(imageName: imageName, text: text, title: title)
        }else {
            nullView.initSetup(imageName: imageName, text: text, title: nil)
        }
        nullView.updateUI()
        
        if belowView != nil {
            superVw.insertSubview(nullView, belowSubview: belowView!)
        }
        else {
            superVw.addSubview(nullView)
        }
        nullView.buttonAction = buttonTapClosure
        
        nullView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        superVw.setNeedsLayout()
        superVw.layoutIfNeeded()
        
        return nullView
    }
    
    static func hideNullDataView(superVw: UIView) {
        
        for subVw in superVw.subviews {
            if let nullView = subVw as? TENullView , nullView.tag == kNullDataViewTag {
                nullView.removeFromSuperview()
            }
        }
    }
    
}
