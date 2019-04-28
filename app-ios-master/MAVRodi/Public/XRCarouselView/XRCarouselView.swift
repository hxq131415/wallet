//
//  XRCarouselView.swift
//  XRCarouselScrollView
//
//  Created by xuran on 17/3/31.
//  Copyright © 2017年 黯丶野火. All rights reserved.
//

/**
 * 自动轮播
 *
 * @by rttx
 */

import UIKit

#if DEBUG
// 只打印信息
func XRLog(message: String) {
    print(message)
}
#else
func XRLog(message: String) {}
#endif

@objc protocol XRCarouselViewDelegate: NSObjectProtocol {
    
    @objc func carouselViewSetImageResource(targetImageView: UIImageView, imgRes: Any)
    @objc optional func carouselViewClickImageView(index: Int)
    @objc optional func carouselViewDidScroll(index: Int)
    @objc optional func carouselViewDidEndDecelerating(index: Int)
}

class XRCarouselView: UIView {
    
    fileprivate lazy var carouseScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var leftImageView: UIImageView = UIImageView()
    fileprivate lazy var centerImageView: UIImageView = UIImageView()
    fileprivate lazy var rightImageView: UIImageView = UIImageView()
    
    fileprivate var pageControl: UIPageControl!
    
    open var pageControlBackgroundColor: UIColor = UIColor.clear {
        didSet {
            pageControl.backgroundColor = pageControlBackgroundColor
        }
    }
    open var pageIndicatorTintColor: UIColor = UIColor.lightGray {
        didSet {
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    open var currentPageIndicatorTintColor: UIColor = UIColor.yellow {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    // 当只有一个资源(图片)时是否启用滚动，默认不启用
    open var isScrollEnabledWhenOneResource: Bool = false
    
    // 轮播时间
    open var speedTime: Double = 1.0 {
        didSet {
            if isAutoCarousel {
                self.stopTimer()
                self.startTimer()
            }
        }
    }
    // 是否自动轮播
    public var isAutoCarousel: Bool = false
        
    fileprivate var curPage: Int = 0
    
    open var imageResArray: [Any] = [] {
        didSet {
            self.resetCarouselScroll()
        }
    }
    
    open var placeHolderImage: UIImage?
    open weak var delegate: XRCarouselViewDelegate?
    fileprivate var timer: Timer?
    
    deinit {
        XRLog(message: "XRCarouselView is dealloc!")
        self.stopTimer()
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialzitionCarouseScrollView()
        self.initialzitionPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialzitionCarouseScrollView()
        self.initialzitionPageControl()
    }
    
    convenience init(frame: CGRect, delegate: XRCarouselViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        carouseScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        carouseScrollView.contentSize = CGSize(width: self.frame.size.width * 3.0, height: 0)
        carouseScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        leftImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        centerImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        rightImageView.frame = CGRect(x: self.frame.size.width * 2.0, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        pageControl.frame = CGRect(x: 0, y: self.frame.size.height - 40.0, width: self.frame.size.width, height: 40.0)
        
        carouseScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
    }
    
    fileprivate func initialzitionCarouseScrollView() {
        
        carouseScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        carouseScrollView.backgroundColor = UIColor.white
        carouseScrollView.showsHorizontalScrollIndicator = false
        carouseScrollView.showsVerticalScrollIndicator = false
        carouseScrollView.isPagingEnabled = true
        carouseScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        carouseScrollView.bounces = true
        carouseScrollView.delegate = self
        
        self.addSubview(carouseScrollView)
        
        leftImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        centerImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        rightImageView.frame = CGRect(x: self.frame.size.width * 2.0, y: 0, width: self.frame.size.width, height: carouseScrollView.frame.size.height)
        
        leftImageView.isUserInteractionEnabled = true
        centerImageView.isUserInteractionEnabled = true
        rightImageView.isUserInteractionEnabled = true
        
        leftImageView.backgroundColor = UIColor.white
        centerImageView.backgroundColor = UIColor.white
        rightImageView.backgroundColor = UIColor.white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewClick(tap:)))
        tapGesture.numberOfTapsRequired = 1
        carouseScrollView.addGestureRecognizer(tapGesture)
        
        carouseScrollView.addSubview(leftImageView)
        carouseScrollView.addSubview(centerImageView)
        carouseScrollView.addSubview(rightImageView)
        
        carouseScrollView.contentSize = CGSize(width: self.frame.size.width * 3.0, height: 0)
    }
    
    fileprivate func initialzitionPageControl() {
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.frame.size.height - 40.0, width: self.frame.size.width, height: 40.0))
        pageControl.isUserInteractionEnabled = false
        pageControl.backgroundColor = pageControlBackgroundColor
        pageControl.numberOfPages = self.imageResArray.count
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.defersCurrentPageDisplay = false
        
        self.addSubview(pageControl)
    }
    
    // MARK: - methods
    @objc fileprivate func imageViewClick(tap: UITapGestureRecognizer) {
        
        if delegate != nil && delegate!.responds(to: #selector(XRCarouselViewDelegate.carouselViewClickImageView(index:))) {
            delegate!.carouselViewClickImageView!(index: curPage)
        }
    }
    
    fileprivate func resetCarouselScroll() {
        
        if imageResArray.count == 0 { return }
        
        pageControl.numberOfPages = self.imageResArray.count
        
        if imageResArray.count == 1 {
            if isScrollEnabledWhenOneResource {
                carouseScrollView.isScrollEnabled = true
                pageControl.isHidden = false
            }
            else {
                carouseScrollView.isScrollEnabled = false
                pageControl.isHidden = true
            }
        }
        else {
            carouseScrollView.isScrollEnabled = true
            pageControl.isHidden = false
        }
        
        let leftIndex = (curPage - 1 + imageResArray.count) % imageResArray.count
        let centerIndex = curPage
        let rightIndex = (curPage + 1 + imageResArray.count) % imageResArray.count
        
        if leftIndex >= imageResArray.count {
            return
        }
        
        if centerIndex >= imageResArray.count {
            return
        }
        
        if rightIndex >= imageResArray.count {
            return
        }
        
        let leftAnyRes = imageResArray[leftIndex]
        let centerAnyRes = imageResArray[centerIndex]
        let rightAnyRes = imageResArray[rightIndex]
        
        if delegate != nil && delegate!.responds(to: #selector(XRCarouselViewDelegate.carouselViewSetImageResource(targetImageView:imgRes:))) {
            delegate!.carouselViewSetImageResource(targetImageView: leftImageView, imgRes: leftAnyRes)
            delegate!.carouselViewSetImageResource(targetImageView: centerImageView, imgRes: centerAnyRes)
            delegate!.carouselViewSetImageResource(targetImageView: rightImageView, imgRes: rightAnyRes)
        }
        
        carouseScrollView.setContentOffset(CGPoint(x: carouseScrollView.frame.width, y: 0), animated: false)
    }
    
    // MARK: - private method
    fileprivate func startTimer() {
        
        if timer != nil { return }
        if speedTime <= 0.01 { return }
        timer = Timer.scheduledTimer(timeInterval: speedTime,
                                     target: self,
                                     selector: #selector(XRCarouselView.scrollToNextPage),
                                     userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func scrollToNextPage() {
        
        if imageResArray.count == 0 {
            return
        }
        
        if carouseScrollView.isDragging || carouseScrollView.isDecelerating {
            return
        }
        
        carouseScrollView.setContentOffset(CGPoint(x: carouseScrollView.frame.width * 2.0, y: 0), animated: true)
    }
    
    // MARK: - Public Methods
    // MARK: - 为了防止内存泄露请在UIViewController的deinit中调用该方法
    public func stopTimer() {
        
        if let tm = timer, tm.isValid {
            tm.invalidate()
            timer = nil
        }
    }
    
    // MARK: - 调用该方法开始循环滚动轮播图
    public func beginAutoScrollCarouselView() {
        
        if self.imageResArray.count > 0 {
            isAutoCarousel = true
            self.startTimer()
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension XRCarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if imageResArray.count == 0 {
            return
        }
        
        let offSetX = scrollView.contentOffset.x
        
        if offSetX <= 0 {
            curPage = (curPage - 1 + imageResArray.count) % imageResArray.count
            self.resetCarouselScroll()
        }
        else if offSetX >= scrollView.frame.width * 2.0 {
            curPage = (curPage + 1 + imageResArray.count) % imageResArray.count
            self.resetCarouselScroll()
        }
        
        if delegate != nil && delegate!.responds(to: #selector(XRCarouselViewDelegate.carouselViewDidScroll(index:))) {
            delegate!.carouselViewDidScroll!(index: curPage)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if curPage < self.imageResArray.count && self.pageControl.currentPage != curPage {
            self.pageControl.currentPage = curPage
        } 
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoCarousel {
            self.startTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isAutoCarousel {
            self.startTimer()
        }
        let offSetX = scrollView.contentOffset.x
        if curPage < self.imageResArray.count {
            self.pageControl.currentPage = curPage
        }
        if offSetX > scrollView.frame.width && offSetX < scrollView.frame.width * 2.0 {
            self.scrollToNextPage()
        }
        
        if delegate != nil && delegate!.responds(to: #selector(XRCarouselViewDelegate.carouselViewDidEndDecelerating(index:))) {
            delegate?.carouselViewDidEndDecelerating!(index: curPage)
        }
    }
    
}



