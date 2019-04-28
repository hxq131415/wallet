//
//  MRMinerFeeView.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  矿工费View

import UIKit

//etc
//private let ETC_Max = 0.08_0000_0000
//private let ETC_Min = 0.0008_0000_0000
private let ETC_Max:UInt64 = 100_0000_0000
private let ETC_Min = 11_0000_0000

//eth
//private let ETH_Max = 0.00151200_0000_0000
//private let ETH_Min = 0.000168_0000_0000
private let ETH_Max:UInt64 = 370_0000_0000
private let ETH_Min:UInt64 = 25_0000_0000

private let ETC_DiV = 55000
private let ETH_DiV = 21000

//private let SliderValueScale: Double = 10_0000

class MRMinerFeeView: UIView {

    lazy var minerTitleLbl: UILabel = UILabel(frame: CGRect.zero)
    lazy var minerSlider: UISlider = UISlider(frame: CGRect.zero)
    lazy var leftTitleLbl: UILabel = UILabel(frame: CGRect.zero)
    lazy var rightTitleLbl: UILabel = UILabel(frame: CGRect.zero)
    lazy var minerNumLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var isETC: Bool = false
    var isETH: Bool = false
    var isMcoins: Bool = false
    var displayValue: String!
    
    var gasPrice_: String!
    // gasPrice
    var gasPrice: String {
        get {

            if isETC {
                // ETC
                let etcValue = NSDecimalNumber(string: displayValue)
                //指数的运算multiplying
                let indexValue = etcValue.multiplying(byPowerOf10: 18)
                //除法的运算dividing
                let divValue = indexValue.dividing(by: NSDecimalNumber(value: ETC_DiV))
                
                let etcValueStr = String(format: "%.f", divValue.doubleValue)
                gasPrice_ = etcValueStr
            }
            else if isMcoins {
                // ETC
                let etcValue = NSDecimalNumber(string: displayValue)
                //指数的运算multiplying
                let indexValue = etcValue.multiplying(byPowerOf10: 18)
                //除法的运算dividing
                let divValue = indexValue.dividing(by: NSDecimalNumber(value: ETC_DiV))
                
                let etcValueStr = String(format: "%.f", divValue.doubleValue)
                gasPrice_ = etcValueStr
            }
            else  {
                // ETH
                let ethValue = NSDecimalNumber(string: displayValue)
                //指数的运算multiplying
                let indexValue = ethValue.multiplying(byPowerOf10: 18)
                //除法的运算dividing
                let divValue = indexValue.dividing(by: NSDecimalNumber(value: ETH_DiV))
                
                let ethValueStr = String(format: "%.f", divValue.doubleValue)
                gasPrice_ = ethValueStr
            }
            
            return gasPrice_
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.subViewInitlzation()
    }
    
    func subViewInitlzation() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        self.addSubview(minerTitleLbl)
        minerTitleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.top.equalToSuperview()
        }
        
        minerTitleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: MinerFeeView_miner_left_title_key), numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        
        self.addSubview(minerSlider)
        minerSlider.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        minerSlider.backgroundColor = UIColor.white
        minerSlider.minimumTrackTintColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        minerSlider.maximumTrackTintColor = UIColorFromRGB(hexRGB: 0xe0e1e2).withAlphaComponent(0.7)
        let image = UIImage(color: UIColorFromRGB(hexRGB: 0x16a2ac), withFrame: CGRect(x: 0, y: 0, width: 11, height: 11))
        if let image_ = image!.imageCompress(to: CGSize(width: 11, height: 11), corners: UIRectCorner.allCorners, cornerRadius: 5.5) {
            minerSlider.setThumbImage(image_, for: UIControlState.normal)
        }
        
        minerSlider.addTarget(self, action: #selector(self.minerSliderValueChangedAction(slider:)), for: UIControlEvents.valueChanged)
        
        self.addSubview(leftTitleLbl)
        leftTitleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalToSuperview()
        }
        
        leftTitleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: MinerFeeView_left_slow_title_key), numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        
        self.addSubview(rightTitleLbl)
        rightTitleLbl.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalToSuperview()
        }
        
        rightTitleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: MinerFeeView_left_fast_title_key), numberOfLines: 1, textAlignment: NSTextAlignment.right, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        
        self.addSubview(minerNumLbl)
        minerNumLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftTitleLbl.snp.right).offset(5)
            make.right.equalTo(self.rightTitleLbl.snp.left).offset(-5)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalToSuperview()
        }
        
        minerNumLbl.configLabel(text: nil, numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
    }
    
    // MARK: - Action
    @objc func minerSliderValueChangedAction(slider: UISlider) {
        
        if isETC {
            // ETC
            let etcValue = NSDecimalNumber(value: slider.value)
            //乘法的运算multiplying
            let divValue = etcValue.multiplying(by: NSDecimalNumber(value: ETC_DiV))
            //指数的运算multiplying
            let indexValue = divValue.multiplying(byPowerOf10: -18)
            //保留8位小数函数方法
            let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            //保留八位小数
            let roundValue = indexValue.rounding(accordingToBehavior: behavor)
            
            let etcValueStr = String(format: "%.8f etc", roundValue.doubleValue)
            minerNumLbl.text = etcValueStr
            displayValue = etcValueStr
            
            //直接返回不换算
//            gasPrice_ = String(format: "%.8f", roundValue.doubleValue)
            
            Log(message: "ETC slider value changed: \(slider.value) \n display value: \(etcValueStr)")
            Log(message: "ETC gasPrice-> \(gasPrice)")
        }
        else if isMcoins {
            // ETC
            let etcValue = NSDecimalNumber(value: slider.value)
            //乘法的运算multiplying
            let divValue = etcValue.multiplying(by: NSDecimalNumber(value: ETC_DiV))
            //指数的运算multiplying
            let indexValue = divValue.multiplying(byPowerOf10: -18)
            //保留8位小数函数方法
            let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            //保留八位小数
            let roundValue = indexValue.rounding(accordingToBehavior: behavor)
            
            let etcValueStr = String(format: "%.8f ether", roundValue.doubleValue)
            minerNumLbl.text = etcValueStr
            displayValue = etcValueStr
            
            //直接返回不换算
            //            gasPrice_ = String(format: "%.8f", roundValue.doubleValue)
            
            Log(message: "ETC slider value changed: \(slider.value) \n display value: \(etcValueStr)")
            Log(message: "ETC gasPrice-> \(gasPrice)")
        }
        else {
            // ETH
            let ethValue = NSDecimalNumber(value: slider.value)
            //乘法的运算multiplying
            let divValue = ethValue.multiplying(by: NSDecimalNumber(value: ETH_DiV))
            //指数的运算multiplying
            let indexValue = divValue.multiplying(byPowerOf10: -18)
            //保留8位小数函数方法
            let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            //保留八位小数
            let roundValue = indexValue.rounding(accordingToBehavior: behavor)
            
            let ethValueStr = String(format: "%.8f ether", roundValue.doubleValue)
            minerNumLbl.text = ethValueStr
            displayValue = ethValueStr
            
            //直接返回不换算 如果需要计算 就放开gasPrice  get里面的的方法
//            gasPrice_ = String(format: "%.8f", roundValue.doubleValue)
            
            Log(message: "ETH slider value changed: \(slider.value) \n display value: \(ethValueStr)")
            Log(message: "ETH gasPrice-> \(gasPrice)")
        }
    }
    
    func configMinerViewWithETC() {
        
        self.isETC = true
        self.isETH = false
        self.isMcoins = false
        //原值 乘 十万（SliderValueScale） 化整
//        let etcMinValue = ETC_Min * SliderValueScale
//        let etcMaxValue = ETC_Max * SliderValueScale
        
        let etcMinValue = Float(ETC_Min)
        let etcMaxValue = Float(ETC_Max)
        
        minerSlider.minimumValue = etcMinValue
        minerSlider.maximumValue = etcMaxValue
        
        let defaultValue = (etcMaxValue - etcMinValue) * 0.05 + etcMinValue
        
        minerSlider.setValue(Float(defaultValue), animated: false)
        
        self.minerSliderValueChangedAction(slider: minerSlider)
    }
    
    func configMinerViewWithETH() {
        
        self.isETH = true
        self.isETC = false
        self.isMcoins = false
        //原值 乘 十万（SliderValueScale） 化整
//        let etcMinValue = ETH_Min * SliderValueScale
//        let etcMaxValue = ETH_Max * SliderValueScale
        
        let etcMinValue = Float(ETH_Min)
        let etcMaxValue = Float(ETH_Max)
        
        minerSlider.minimumValue = etcMinValue
        minerSlider.maximumValue = etcMaxValue
        
        let defaultValue = (etcMaxValue - etcMinValue) * 0.05 + etcMinValue
        
        minerSlider.setValue(Float(defaultValue), animated: false)
        
        self.minerSliderValueChangedAction(slider: minerSlider)
    }
    func configMinerViewWithMcoins() {
        
        self.isMcoins = true
        self.isETH = false
        self.isETC = false
        //原值 乘 十万（SliderValueScale） 化整
        //        let etcMinValue = ETC_Min * SliderValueScale
        //        let etcMaxValue = ETC_Max * SliderValueScale
        
        let etcMinValue = Float(ETC_Min)
        let etcMaxValue = Float(ETC_Max)
        
        minerSlider.minimumValue = etcMinValue
        minerSlider.maximumValue = etcMaxValue
        
        let defaultValue = (etcMaxValue - etcMinValue) * 0.05 + etcMinValue
        
        minerSlider.setValue(Float(defaultValue), animated: false)
        
        self.minerSliderValueChangedAction(slider: minerSlider)
    }
    
}

/*
 
 // MARK: - Action
 @objc func minerSliderValueChangedAction(slider: UISlider) {
 
 if isETC {
 // ETC
 let etcValue = NSDecimalNumber(value: slider.value)
 let divValue = etcValue.dividing(by: NSDecimalNumber(value: SliderValueScale))
 let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
 let roundValue = divValue.rounding(accordingToBehavior: behavor)
 
 let etcValueStr = String(format: "%.8f etc", roundValue.doubleValue)
 minerNumLbl.text = etcValueStr
 displayValue = etcValueStr
 //直接返回不换算
 gasPrice_ = String(format: "%.8f", roundValue.doubleValue)
 
 Log(message: "ETC slider value changed: \(slider.value) \n display value: \(etcValueStr)")
 Log(message: "ETC gasPrice-> \(gasPrice)")
 }
 else {
 // ETH
 /*
 slider.value 这个值比原值大了10万（SliderValueScale）为了化整
 divValue 不四舍五入 除于10万（SliderValueScale）  等于原值
 behavor 保留八位小数的公式函数
 roundValue  不进位保留八位小数后的值  正确值展示值
 */
 let etcValue = NSDecimalNumber(value: slider.value)
 let divValue = etcValue.dividing(by: NSDecimalNumber(value: SliderValueScale))
 let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
 let roundValue = divValue.rounding(accordingToBehavior: behavor)
 
 let etcValueStr = String(format: "%.8f ether", roundValue.doubleValue)
 minerNumLbl.text = etcValueStr
 displayValue = etcValueStr
 //直接返回不换算 如果需要计算 就放开gasPrice  get里面的的方法
 gasPrice_ = String(format: "%.8f", roundValue.doubleValue)
 
 Log(message: "ETH slider value changed: \(slider.value) \n display value: \(etcValueStr)")
 Log(message: "ETH gasPrice-> \(gasPrice)")
 }
 }
 
 func configMinerViewWithETC() {
 
 self.isETC = true
 //原值 乘 十万（SliderValueScale） 化整
 let etcMinValue = ETC_Min * SliderValueScale
 let etcMaxValue = ETC_Max * SliderValueScale
 
 minerSlider.minimumValue = Float(etcMinValue)
 minerSlider.maximumValue = Float(etcMaxValue)
 
 let defaultValue = (etcMaxValue - etcMinValue) * 0.05 + etcMinValue
 
 minerSlider.setValue(Float(defaultValue), animated: false)
 
 self.minerSliderValueChangedAction(slider: minerSlider)
 }
 
 func configMinerViewWithETH() {
 
 self.isETC = false
 //原值 乘 十万（SliderValueScale） 化整
 let etcMinValue = ETH_Min * SliderValueScale
 let etcMaxValue = ETH_Max * SliderValueScale
 
 minerSlider.minimumValue = Float(etcMinValue)
 minerSlider.maximumValue = Float(etcMaxValue)
 
 let defaultValue = (etcMaxValue - etcMinValue) * 0.05 + etcMinValue
 
 minerSlider.setValue(Float(defaultValue), animated: false)
 
 self.minerSliderValueChangedAction(slider: minerSlider)
 }
 
 
 */
