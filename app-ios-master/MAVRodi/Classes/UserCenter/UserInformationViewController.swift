//
//  UserInformationViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/4.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  我的信息

import UIKit

class UserInformationViewController: MRBaseViewController {

    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    lazy var exitBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    var dataArray: [String] = []
    var userData: UserDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_navigation_title_key)
        
        dataArray.append(MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_current_account_title_key))
        dataArray.append(MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_payment_password_title_key))
        dataArray.append(MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_nickname_modify_title_key))
        dataArray.append(MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_avatar_modify_title_key))
        
        self.subViewInitalzations()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.default
    }
    
    override var statusBarBackgroundColor: UIColor? {
        return MRColorManager.StatusBarBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initlzations
    func subViewInitalzations() {
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = MRColorManager.TableViewSeparatorLineDarkColor
        mainTableView.backgroundColor = MRColorManager.Table_Collection_ViewBackgroundColor
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        self.view.addSubview(exitBtn)
        exitBtn.snp.makeConstraints { (make) in
            make.width.equalTo(340 * theScaleToiPhone_6)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30 - Main_IndicatorBar_Height)
            make.centerX.equalToSuperview().offset(0)
        }
        
        exitBtn.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        exitBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x424458), for: UIControlState.normal)
        exitBtn.titleLabel?.textAlignment = .center
        exitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        exitBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_exit_button_title_key), for: UIControlState.normal)
        
        exitBtn.layer.cornerRadius = 5
        exitBtn.layer.shadowColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.2).cgColor
        exitBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        exitBtn.layer.shadowRadius = 15
        exitBtn.layer.shadowOpacity = 1
        
        exitBtn.addTarget(self, action: #selector(self.exitAccountBtnAction), for: UIControlEvents.touchUpInside)
        
        let versionLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(versionLbl)
        versionLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.exitBtn.snp.top).offset(-40)
            make.height.greaterThanOrEqualTo(10)
        }
        
        let leftTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: UserInformation_current_version_text_key)
        if let appVersion = appBundleShortVersion {
            versionLbl.configLabel(text: "\(leftTitle) v\(appVersion)", textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 15))
        }
        
    }
    
    // MARK: - Action
    @objc func exitAccountBtnAction() {
        
        MRCommonShared.shared.cleanUserLoginInfo()
        self.navigationController?.popToRootViewController(animated: false)
        
        (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
    }
    
    //MARK: - 打开相册
    func openPhotoAlbum() {
        
        MRTools.checkPhotoLibraryAuthorization(presentViewCtrl: self) { (state) in
            if state == true {
                
                let photoPicker = XRPhotoPickerViewController()
                photoPicker.delegate = self
                photoPicker.isAllowMultipleSelect = false
                photoPicker.isAllowCrop = true
                photoPicker.isAscingForCreation = false
                photoPicker.isPortrait = true
                photoPicker.isSupportCamera = true
                photoPicker.statusBarStyle = UIStatusBarStyle.lightContent
                photoPicker.cropSize = CGSize(width: photoPicker.screenWidth, height: photoPicker.screenWidth)
                self.pushToViewController(viewCtrl: photoPicker)
            }
        }
        
    }
    
    // MARK: - Request
    func requestForUploadAvatar(avatarImgSting: String) {
        
        var params: [String: Any] = [:]
        params["avatar"] = avatarImgSting
        
        self.show(withMessage: MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyHeadImage_uploading_text_key), in: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_MODIFY_AVATAR, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                weakSelf.hideHUD()
                if status == 0 {
                    if let msg = message , !msg.isEmpty {
                        weakSelf.showBottomMessage(msg)
                    }
                    else {
                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyHeadImage_upload_success_text_key))
                    }
                }
                else {
                    if let msg = message , !msg.isEmpty {
                        weakSelf.showBottomMessage(msg)
                    }
                    else {
                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyHeadImage_upload_faild_text_key))
                    }
                }
            }
        }
    }
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension UserInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellForUserCenter")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCellForUserCenter")
        }
        
        cell?.selectionStyle = .default
        
        let text = dataArray[indexPath.row]
        
        cell?.textLabel?.textColor = MRColorManager.DarkBlackTextColor
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cell?.textLabel?.text = text
        
        if indexPath.row == 0 {
            cell?.accessoryType = .none
            
            let rightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
            rightLbl.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
            rightLbl.textAlignment = .right
            rightLbl.font = UIFont.systemFont(ofSize: 13)
            rightLbl.text = userData?.account
            rightLbl.sizeToFit()
            
            cell?.accessoryView = rightLbl
            
            cell?.textLabel?.sizeToFit()
        }
        else {
            cell?.accessoryView = nil
            cell?.accessoryType = .disclosureIndicator
        }
        
        return cell ?? tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            let loginPasswordCtrl = MRPaymentPasswordInputController()
            loginPasswordCtrl.modalPresentationStyle = .overFullScreen
            self.present(loginPasswordCtrl, animated: false) {
                loginPasswordCtrl.showAlert()
            }
            break
        case 2:
            let modifyNickNameAlertCtrl = MRModifyNickNameAlertController()
            modifyNickNameAlertCtrl.modalPresentationStyle = .overFullScreen
            self.present(modifyNickNameAlertCtrl, animated: false) {
                modifyNickNameAlertCtrl.showAlert()
            }
        case 3:
            self.openPhotoAlbum()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

// MARK: - XRPhotoPickerControllerDelegate
extension UserInformationViewController: XRPhotoPickerControllerDelegate {
    
    func xr_photoPickerController(_ picker: XRPhotoPickerViewController!, didSelectAssetWithCropImage cropImaage: UIImage!) {
        
        if let navigationCtrl = self.navigationController , navigationCtrl.viewControllers.count > 1 {
            navigationCtrl.popToViewController(self, animated: true)
        }
        
        // 压缩并上传图片到服务器
        cropImaage.compressImageScaled(to: CGSize(width: 250, height: 250), toMBSize: 1.0) { (compressedImg, compressedData) in
            if let data = compressedData {
                let dataContentType = (data as NSData).skContentTypeForImageData()
                let imgBase64String = data.base64EncodedString()
                let avatarImgString = "data:\(dataContentType ?? "image/jpg");base64,\(imgBase64String)"
                self.requestForUploadAvatar(avatarImgSting: avatarImgString)
            }
        }
    }
    
    func xr_photoPickerController(_ picker: XRPhotoPickerViewController!, didSelectAssetWithOriginalImage originalImaage: UIImage!) {
        
    }
    
    func xr_photoPickerControllerDidCancel(_ picker: XRPhotoPickerViewController!) {
        
        picker.navigationController?.popViewController(animated: true)
    }
    
}

