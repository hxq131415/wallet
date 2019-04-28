//
//  PlanRewardContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class PlanRewardContentView: UIView, UITextFieldDelegate {

    @IBOutlet weak var backgroundImgVw: UIImageView!
    @IBOutlet weak var shareTextLbl: UILabel!
    @IBOutlet weak var sharingRewardTextField: UITextField!
    @IBOutlet weak var gameTextLbl: UILabel!
    @IBOutlet weak var gameEnarningsTextField: UITextField!
    
    var sharingRightVw: UIButton!
    var gameRightVw: UIButton!
    @IBOutlet weak var bottomLbl: UILabel!
    
    var selectBtn: UIButton?
    var model: PlanHarvestAmountModel?
    
    var selectHarvestTypeBtnTapClosure: ((_ rewardModel: HarvestAmountModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImgVw.isUserInteractionEnabled = true
        
        sharingRewardTextField.backgroundColor = UIColorFromRGB(hexRGB: 0x06164f)
        sharingRewardTextField.layer.masksToBounds = true
        sharingRewardTextField.layer.cornerRadius = 21.0
        sharingRewardTextField.delegate = self
        sharingRewardTextField.font = UIFont.boldSystemFont(ofSize: 17)
        sharingRewardTextField.textColor = UIColorFromRGB(hexRGB: 0xffcc57)
        sharingRewardTextField.textAlignment = .center
        
        let sharingRightBackVw = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        
        sharingRightVw = UIButton(frame: CGRect(x: (42 - 25) * 0.5, y: (42 - 25) * 0.5, width: 25, height: 25))
        sharingRightVw.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x7e7e7e), withFrame: sharingRightVw.bounds), for: UIControlState.normal)
        sharingRightVw.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0xffcc57), withFrame: sharingRightVw.bounds), for: UIControlState.selected)
        sharingRightVw.layer.masksToBounds = true
        sharingRightVw.layer.cornerRadius = 12.5
        sharingRightVw.tag = 1001
        sharingRightBackVw.addSubview(sharingRightVw)
        
        sharingRightVw.addTarget(self, action: #selector(self.rightBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        sharingRewardTextField.rightView = sharingRightBackVw
        sharingRewardTextField.rightViewMode = .always
        
        gameEnarningsTextField.backgroundColor = UIColorFromRGB(hexRGB: 0x06164f)
        gameEnarningsTextField.layer.masksToBounds = true
        gameEnarningsTextField.layer.cornerRadius = 21.0
        gameEnarningsTextField.delegate = self
        gameEnarningsTextField.font = UIFont.boldSystemFont(ofSize: 17)
        gameEnarningsTextField.textColor = UIColorFromRGB(hexRGB: 0xffcc57)
        gameEnarningsTextField.textAlignment = .center
        
        let gameRightBackVw = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        
        gameRightVw = UIButton(frame: CGRect(x: (42 - 25) * 0.5, y: (42 - 25) * 0.5, width: 25, height: 25))
        gameRightVw.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x7e7e7e), withFrame: gameRightVw.bounds), for: UIControlState.normal)
        gameRightVw.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0xffcc57), withFrame: gameRightVw.bounds), for: UIControlState.selected)
        gameRightVw.layer.masksToBounds = true
        gameRightVw.layer.cornerRadius = 12.5
        gameRightVw.tag = 1002
        gameRightBackVw.addSubview(gameRightVw)
        
        gameEnarningsTextField.rightView = gameRightBackVw
        gameEnarningsTextField.rightViewMode = .always
        
        sharingRewardTextField.isUserInteractionEnabled = true
        gameEnarningsTextField.isUserInteractionEnabled = true
        
        gameRightVw.addTarget(self, action: #selector(self.rightBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        
        bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_bottom_lbl_text_key)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func rightBtnAction(btn: UIButton) {
        
        if selectBtn != btn {
            btn.isSelected = true
            selectBtn?.isSelected = false
            selectBtn = btn
            
            if btn.tag == 1001 {
                if self.selectHarvestTypeBtnTapClosure != nil , let gamReward = self.model?.gameReward {
                    self.selectHarvestTypeBtnTapClosure!(gamReward)
                }
            }
            else {
                if self.selectHarvestTypeBtnTapClosure != nil , let sysReward = self.model?.sysReward {
                    self.selectHarvestTypeBtnTapClosure!(sysReward)
                }
            }
        }
    }
    
    func configWithHarvestAmountModel(model: PlanHarvestAmountModel?) {
        
        self.model = model
        shareTextLbl.text = "\(model?.gameReward?.name ?? "")（ETC）"
        sharingRewardTextField.text = String(format: "%.6f", model?.gameReward?.amount ?? 0)
        
        gameTextLbl.text = "\(model?.sysReward?.name ?? "")（ETC）"
        gameEnarningsTextField.text = String(format: "%.6f", model?.sysReward?.amount ?? 0)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == sharingRewardTextField || textField == gameEnarningsTextField {
            return false
        }
        return true
    }
    
}
