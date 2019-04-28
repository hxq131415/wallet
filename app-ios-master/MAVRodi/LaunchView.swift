//
//  ViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/29.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchView: UIView {
    
    fileprivate var playItem:AVPlayerItem{
        get{
            //视频路径
            let resource:String = iSiPhoneX() ? "828-1792-LAST":"750-1334-LAST"
            guard let path = Bundle.main.path(forResource: resource, ofType: "mp4") else {
                fatalError("视频路径出错")
            }
            let url = URL(fileURLWithPath: path)
            let playItem = AVPlayerItem(url: url)
            return playItem
        }
    }
    
    fileprivate lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem:playItem)
        player.actionAtItemEnd = .pause
        //设置播放完成后发送通知
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTimeNotification(noti:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        return player
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //这里需要根据内容切换显示图片视图还是显示视频视图
        setupVideoUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        setupUI()
    }

    @objc private func dismiss(){
        
        guard let window = UIApplication.shared.delegate?.window else{
            return;
        }
        window?.isHidden = false
        window?.addSubview(self)
        
        let launchView: UIImageView = UIImageView()
        launchView.frame = self.bounds
        launchView.image = UIImage(named:"Launch")
        window?.addSubview(launchView)
        launchView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            //make.size.equalTo(CGSize(width: 374, height: 337))
        }
        
        //延时1秒执行
        let time: TimeInterval = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            print("3 秒后输出")
            launchView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                //缩放
                //            self.imgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
                //渐隐
                self.alpha = 0
            }, completion: { Bool in
                self.removeFromSuperview()
            })
        }
        
      
    }
    
    deinit {
        print("启动页移除")
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:- 视频相关
extension LaunchView{
    
    fileprivate func setupVideoUI(){
        backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(playVideos), name: NSNotification.Name(rawValue: "appBecomeActive"), object: nil)
        setupForAVplayerView()
        player.play()
        
        guard let window = UIApplication.shared.delegate?.window else{
            dismiss()
            return;
        }
        window?.isHidden = false
        window?.addSubview(self)
        
        
        
//        //跳过广告
  
    }
    
    private func setupForAVplayerView(){
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(videoAdTouch))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
    }
    
    @objc private func playerItemDidPlayToEndTimeNotification(noti:Notification){
        player.pause()
        dismiss()
    }
    
    @objc private func videoAdTouch(){
//        player.pause()
        //视频被点击 可以发送通知让进行跳转
//        dismiss()
    }
    
    @objc private func playVideos(){
        player.play()
    }
}
