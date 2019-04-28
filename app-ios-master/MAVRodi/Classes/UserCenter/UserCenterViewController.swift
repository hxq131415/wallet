//
//  UserCenterViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/31.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  个人中心

import UIKit

class UserCenterViewController: MRBaseViewController {
    
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    var tableHeaderVw: UserCenterTableHeaderView!
    
    var userInfoModel: UserDataModel?
    var dataArray: [[(String, String)]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserData), name: NSNotification.Name(rawValue: NNKEY_NEED_TO_UPDATE_USERDATA_NOTIFICATION), object: nil)
        
        self.dataInitialization()
        self.subViewInitalzations()
        self.requestForGetUserData(isSilentlyLoading: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MRCommonShared.shared.loginInfo != nil {
            self.requestForGetUserData(isSilentlyLoading: true)
        }
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
        mainTableView.separatorColor = UIColorFromRGB(hexRGB: 0xf7f6fb)
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xf5f5f5)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 35))
    }
    
    func dataInitialization() {
        
        dataArray.removeAll()
        var sec1 = [(String , String)]()
        sec1.append(("icon_usercenter_userinfo", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_my_information_title_key)))
        sec1.append(("icon_usercenter_invitation", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_my_sharing_title_key)))
        dataArray.append(sec1)
        
        var sec2 = [(String , String)]()
        sec2.append(("icon_usercenter_assets", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_high_frequency_title_key)))
        sec2.append(("icon_usercenter_lucky", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_lucky_wheel_title_key)))
        sec2.append(("icon_usercenter_language", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_select_language_title_key)))
        sec2.append(("icon_usercenter_announcement", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_announcement_title_key)))
#if DEBUG
        sec2.append(("icon_usercenter_language", "环境切换"))
#endif
        dataArray.append(sec2)
        
        var sec3 = [(String , String)]()
        sec3.append(("icon_usercenter_version", MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_version_title_key)))
        dataArray.append(sec3)
        
    }
    
    // MARK: - Action
    func gotoInvitation() {
        
        let inviteViewCtrl = MyInvitationViewController()
        inviteViewCtrl.qrcodeString = self.userInfoModel?.download_url ?? ""
        inviteViewCtrl.invitationCode = self.userInfoModel?.invitationCode
        self.navigationController?.pushViewController(inviteViewCtrl, animated: true)
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
                photoPicker.statusBarStyle = UIStatusBarStyle.default
                photoPicker.cropSize = CGSize(width: photoPicker.screenWidth, height: photoPicker.screenWidth)
                self.pushToViewController(viewCtrl: photoPicker)
            }
        }
        
    }
    
    // 切换语言
    func changeAppLanguage() {
        
        let alertViewCtrl = UIAlertController(title: "切换语言", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            
        }
        
        cancelAction.setValue(UIColorFromRGB(hexRGB: 0x16A2Ac), forKey: "titleTextColor")
        
        let enAction = UIAlertAction(title: "English", style: UIAlertActionStyle.default) { [weak self](_) in
            if let weakSelf = self {
                if !(MRTools.currentSystemLanguageType() == .en_us) {
                    UserDefaults.standard.setValue(MRSystemLanaguageType.en_us.rawValue, forKey: UDKEY_APP_CURRENT_SET_LANGUAGE)
                    UserDefaults.standard.synchronize()
                    
                    weakSelf.show(withMessage: "Are set language...", in: weakSelf.view)
                    dispatch_after_in_main(2, block: {
                        weakSelf.hideHUD()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION), object: nil, userInfo: nil)
                    })
                }
            }
        }
        enAction.setValue(UIColorFromRGB(hexRGB: 0x16A2Ac), forKey: "titleTextColor")
        let zhAction = UIAlertAction(title: "简体中文", style: UIAlertActionStyle.default) { [weak self](_) in
            if let weakSelf = self {
                if !(MRTools.currentSystemLanguageType() == .zh_cn) {
                    UserDefaults.standard.setValue(MRSystemLanaguageType.zh_cn.rawValue, forKey: UDKEY_APP_CURRENT_SET_LANGUAGE)
                    UserDefaults.standard.synchronize()
                    
                    weakSelf.show(withMessage: "正在设置语言...", in: weakSelf.view)
                    dispatch_after_in_main(3, block: {
                        weakSelf.hideHUD()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION), object: nil, userInfo: nil)
                    })
                }
            }
        }
        zhAction.setValue(UIColorFromRGB(hexRGB: 0x16A2Ac), forKey: "titleTextColor")
        alertViewCtrl.addAction(zhAction)
        alertViewCtrl.addAction(enAction)
        alertViewCtrl.addAction(cancelAction)
        self.present(alertViewCtrl, animated: true, completion: nil)
    }
    
    // 切换环境
    func changeAppRequestAPI() {
        
        let alertViewCtrl = UIAlertController(title: "切换环境", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            
        }
        
        let enAction = UIAlertAction(title: "测试环境", style: UIAlertActionStyle.default) { [weak self](_) in
            if let weakSelf = self {
                
                if let requestAPIValue = UserDefaults.standard.value(forKey: "PSWrequestAPI") as? String {
                    
                    if requestAPIValue == "true" {
                        UserDefaults.standard.setValue("false", forKey: "PSWrequestAPI")
                        UserDefaults.standard.synchronize()
                        weakSelf.show(withMessage: "正在切换...", in: weakSelf.view)
                        TERequestManager.changeRequestEnvironment(isRelease: false)
                        dispatch_after_in_main(2, block: {
                            weakSelf.hideHUD()
                            MRCommonShared.shared.cleanUserLoginInfo()
                        weakSelf.navigationController?.popToRootViewController(animated: false)
                            (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
                        })
                    }
                }
            }
        }
        
        let zhAction = UIAlertAction(title: "正式环境", style: UIAlertActionStyle.default) { [weak self](_) in
            if let weakSelf = self {
                
                if let requestAPIValue = UserDefaults.standard.value(forKey: "PSWrequestAPI") as? String {
                    
                    if requestAPIValue == "false" {
                        UserDefaults.standard.setValue("true", forKey: "PSWrequestAPI")
                        UserDefaults.standard.synchronize()
                        weakSelf.show(withMessage: "正在切换...", in: weakSelf.view)
                        TERequestManager.changeRequestEnvironment(isRelease: true)
                        dispatch_after_in_main(2, block: {
                            weakSelf.hideHUD()
                            MRCommonShared.shared.cleanUserLoginInfo()
                            weakSelf.navigationController?.popToRootViewController(animated: false)
                            (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
                        })
                    }
                }
            }
        }
        
        alertViewCtrl.addAction(zhAction)
        alertViewCtrl.addAction(enAction)
        alertViewCtrl.addAction(cancelAction)
        self.present(alertViewCtrl, animated: true, completion: nil)
    }
    
    // 更新数据
    @objc func updateUserData() {
        
        self.requestForGetUserData(isSilentlyLoading: true)
    }
    
    // MARK: - Request
    func requestForGetUserData(isSilentlyLoading: Bool = false) {
        
        if !isSilentlyLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_USERDATA, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.userInfoModel = UserDataModel(JSON: dict)
                        MRCommonShared.shared.userInfo = weakSelf.userInfoModel
                        MRCommonShared.shared.loginInfo?.userInfo = weakSelf.userInfoModel
                    }
                    
                    weakSelf.mainTableView.reloadData()
                }
                else if status == 21
                {
                    MRCommonShared.shared.cleanUserLoginInfo()
                    weakSelf.navigationController?.popToRootViewController(animated: false)
                    (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
                }
                else {
                    // 加载失败了
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showBottomMessage(errMsg)
                    }
                    else {
                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                }
            }
        }
    }
    
    // 上传头像
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
                    
                    if MRCommonShared.shared.loginInfo != nil {
                        weakSelf.requestForGetUserData(isSilentlyLoading: true)
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
    
    // App语言切换
    override func appLanguageChanged(notifi: Notification) {
        
        self.dataInitialization()
        self.requestForGetUserData(isSilentlyLoading: true)
        self.mainTableView.reloadData()
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension UserCenterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellForUserCenter")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCellForUserCenter")
        }
        
        cell?.selectionStyle = .default
        
        let (imageName, text) = dataArray[indexPath.section][indexPath.row]
        
        cell?.imageView?.image = UIImage(named: imageName)
        
        cell?.textLabel?.textColor = MRColorManager.DarkBlackTextColor
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cell?.textLabel?.text = text
        
        if indexPath.section == 1 || indexPath.section == 2 {
            
            let rightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
            rightLbl.textColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
            rightLbl.textAlignment = .right
            rightLbl.font = UIFont.systemFont(ofSize: 14)
            if indexPath.section == 1 && indexPath.row == 2 {
//            if indexPath.section == 1 && indexPath.row == 1 {
                if MRTools.currentSystemLanguageType() == .en_us {
                    rightLbl.text = "English"
                }
                else {
                    rightLbl.text = "简体中文"
                }
                
            }else if indexPath.section == 1 && indexPath.row == 4 {
//            }else if indexPath.section == 1 && indexPath.row == 3 {
                
                if let requestAPIValue = UserDefaults.standard.value(forKey: "PSWrequestAPI") as? String {
                    
                    if requestAPIValue == "false" {
                        rightLbl.text = "测试环境"
                    }
                    else
                    {
                        rightLbl.text = "正式环境"
                    }
                }
                else {
                    rightLbl.text = "测试环境"
                }
            }else if indexPath.section == 2 && indexPath.row == 0 {
                
                if let appVersion = appBundleShortVersion {
                    rightLbl.text = "v.\(appVersion)"
                }
            }
            cell?.accessoryView = rightLbl
            cell?.accessoryType = .disclosureIndicator
        }
        else {
            cell?.accessoryView = nil
            cell?.accessoryType = .disclosureIndicator
        }
        
        return cell ?? tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let informationViewCtrl = UserInformationViewController()
                informationViewCtrl.userData = self.userInfoModel
                self.navigationController?.pushViewController(informationViewCtrl, animated: true)
            }else {
                self.gotoInvitation()
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
                self.showBottomMessage(message)
            }else if indexPath.row == 1 {
                // 保本兑换
//                HarvestConfirmAlertView.showHarvestConfirmAlertViewWithDetail(superV: ShareDelegate.window ?? self.view, title:"兑换重启", detail:"兑换重启，系统会将兑换的Mcoin自动转入个人钱包，然后清除所有投资记录实现重启")
//                {
                    ///确认请求
                    let MPlanBillsViewCtrl = MavrodiPlanBillsViewController()
                    
                    self.pushToViewController(viewCtrl: MPlanBillsViewCtrl)
//                }
                
                
            }else if indexPath.row == 2 {
                // 切换语言
                self.changeAppLanguage()
            }else if indexPath.row == 3{
                // 系统公告
                let announcementListCtrl = AnnouncementListViewController()
                self.navigationController?.pushViewController(announcementListCtrl, animated: true)
            }
            else{
                // 切换环境
                self.changeAppRequestAPI()
            }
        }
        else {//版本更新
            self.pushToViewController(viewCtrl: UpdateViewController())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let tableHeaderVw = Bundle.main.loadNibNamed("UserCenterTableHeaderView", owner: nil, options: nil)?.first as! UserCenterTableHeaderView
            tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 294)
            
            tableHeaderVw.configHeaderViewWithUserModel(userInfo: self.userInfoModel)
            
            tableHeaderVw.headImageViewTapClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.openPhotoAlbum()
                }
            }
            
            tableHeaderVw.addFriendBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.gotoInvitation()
                }
            }
            
            tableHeaderVw.textLblTapClosure = { [weak self] (isTapLeftLbl) in
                if let weakSelf = self {
                    let rewardViewCtrl = ManagerRewardViewController()
                    rewardViewCtrl.rewardType = isTapLeftLbl ? MRRewardType.sharing : MRRewardType.leadership
                    weakSelf.navigationController?.pushViewController(rewardViewCtrl, animated: true)
                }
            }
            
            return tableHeaderVw
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 230
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

// MARK: - XRPhotoPickerControllerDelegate
extension UserCenterViewController: XRPhotoPickerControllerDelegate {
    
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


