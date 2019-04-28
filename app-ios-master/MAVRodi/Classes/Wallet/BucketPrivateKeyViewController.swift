//
//  BucketPrivateKeyViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  备份私钥

import UIKit

class BucketPrivateKeyViewController: MRBaseViewController {

    private lazy var mainTableView: UITableView =
        UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    var privateKeyModel: CreateWalletPrivateKeyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_navigation_title_key)
        
        self.initalizationSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isNavigationBarToHidden() {
            self.customLeftBackItemButtonWithImageName("icon_back_black")
            self.customNavigationTitleAttributes()
            self.customNavigationBarBackgroundImageWithoutBottomLine()
        }
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Overrides
    override func customNavigationTitleAttributes() {
        
        let paragphStyle = NSMutableParagraphStyle()
        paragphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColorFromRGB(hexRGB: 0x333333), NSAttributedStringKey.font : TE_NavigationTitle_Font, NSAttributedStringKey.paragraphStyle: paragphStyle]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    override func customNavigationBarBackgroundImageWithoutBottomLine() {
        
        let navBgImg = UIImage(color: MRColorManager.LightGrayBackgroundColor)
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Initialization
    func initalizationSubView() {
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    }
    
    // MARK: - Action
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            if let textLbl = gesture.view as? UILabel {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = textLbl.text
                
            }
            break
        case .cancelled:
            break
        case .changed:
            break
        case .ended:
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_copyed_prompt_text_key))
            break
        default:
            break
        }
    }
    
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension BucketPrivateKeyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = Bundle.main.loadNibNamed("BucketPrivateKeyContentView", owner: nil, options: nil)?.first as? BucketPrivateKeyContentView {
            
            headerView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 594)
            
            headerView.ethPrivateKeyLbl.text = privateKeyModel.eth_privateKey
            headerView.etcPrivateKeyLbl.text = privateKeyModel.etc_privateKey
            
            let ethLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gesture:)))
            headerView.ethPrivateKeyLbl.isUserInteractionEnabled = true
            headerView.ethPrivateKeyLbl.addGestureRecognizer(ethLongPress)
            
            let etcLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gesture:)))
            headerView.etcPrivateKeyLbl.isUserInteractionEnabled = true
            headerView.etcPrivateKeyLbl.addGestureRecognizer(etcLongPress)
            
            headerView.checkPrivateKeyBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    let privateKeyDesCtrl = PrivateKeyDescripViewController()
                    weakSelf.navigationController?.pushViewController(privateKeyDesCtrl, animated: true)
                }
            }
            
            headerView.confirmBtnTapClosure = {[weak self] in
                if let weakSelf = self {
                    saveUserDefaultsWithValue(value: true, key: isBucketPrivate())
                    weakSelf.navigationController?.popViewController(animated: true)
                }
            }
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 619
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
