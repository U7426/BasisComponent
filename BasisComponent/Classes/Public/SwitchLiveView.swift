//
//  SwitchLiveView.swift
//  KDLive
//
//  Created by 冯龙飞 on 2019/11/14.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

import UIKit
import Kingfisher
fileprivate enum Location {
    case top
    case middle
    case bottom
}
public protocol SwitchProtrol{
    var cover : String { get }
}
public class SwitchLiveView<T:SwitchProtrol>: UIScrollView,UIScrollViewDelegate where T : AnyObject{
    public typealias changeBlock = ((_ old:T,_ new:T)->())?
    var topCoverView : UIImageView
    var middleCoverView : UIImageView
    var bottomCoverView : UIImageView
    var lives:[T]?
    lazy var covers:[String] = []
    var oldInfo:T?
    var liveInfo:T
    var change : changeBlock
    
    /// 初始化
    /// - Parameters:
    ///   - views: 上面要放的涂层
    ///   - lives: model列表
    ///   - liveInfo: 当前model
    ///   - change: 回调
    public init(views:[UIView]?,lives:[T]?,liveInfo:T,change:changeBlock) {
        self.lives = lives
        self.liveInfo = liveInfo
        self.change = change
        self.topCoverView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        self.topCoverView.contentMode = .scaleAspectFill
        self.topCoverView.clipsToBounds = true
        self.middleCoverView = UIImageView(frame: CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height))
        self.middleCoverView.isUserInteractionEnabled = true
        self.middleCoverView.contentMode = .scaleAspectFill
        self.middleCoverView.clipsToBounds = true
        self.bottomCoverView = UIImageView(frame: CGRect(x: 0, y:2 * UIScreen.height, width: UIScreen.width, height: UIScreen.height))
        self.bottomCoverView.contentMode = .scaleAspectFill
        self.bottomCoverView.clipsToBounds = true
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        self.addSubview(self.topCoverView)
        self.addSubview(self.middleCoverView)
        self.addSubview(self.bottomCoverView)
        self.scrollsToTop = false
        self.isPagingEnabled = true
        self.contentSize = CGSize(width: UIScreen.width, height: UIScreen.height * 3)
        self.setContentOffset(CGPoint(x: 0, y: UIScreen.height), animated: false)
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        for item in views ?? [] {
            item.frame.origin.y = UIScreen.height
            self.addSubview(item)
        }
        self.sortImageAndShowModelDidEndDecelerating(location: .middle)
        self.setThreeCoverImage()
        defer {
            if #available(iOS 11.0, *) {
                self.contentInsetAdjustmentBehavior = .never
            }
            else{
                UIViewController.presentingVC()?.automaticallyAdjustsScrollViewInsets = false;
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func sortImageAndShowModelDidEndDecelerating(location:Location) {
        self.covers.removeAll()
        var index = self.lives?.firstIndex(where: { (e) -> Bool in
            return e === self.liveInfo
            }) ?? 0
        self.oldInfo = self.liveInfo
        switch location {
        case .top:
            if index == 0{
                self.liveInfo = (self.lives?.last ?? self.liveInfo) 
            }
            else{
                if index - 1 >= 0 {
                    self.liveInfo = self.lives?[index - 1] ?? self.liveInfo
                }
            }
        case .middle:
            break
        case.bottom:
            if index == (self.lives?.count ?? 0) - 1 {
                self.liveInfo = (self.lives?.first ?? self.liveInfo) 
            }
            else{
                if index + 1 < lives?.count ?? 0 {
                    self.liveInfo = self.lives?[index + 1] ?? self.liveInfo
                }
            }
        }
        index = self.lives?.firstIndex(where: { (e) -> Bool in
            return e === self.liveInfo
        }) ?? 0
        addImageToArray(index: index)
    }
    func addImageToArray(index:Int) {
        guard let lives = self.lives else{
            self.covers = Array.init(repeating:self.liveInfo.cover, count: 3)
            return
        }
        var info : T?
        if index == 0 {
            info = lives.last
        }
        else{
            if index - 1 >= 0{
                info = lives[index - 1]
            }
        }
        self.covers.append(info?.cover ?? self.liveInfo.cover)
        self.covers.append(self.liveInfo.cover)
        if index == lives.count - 1 {
            info = lives.first
        }
        else {
            if lives.count > index + 1 {
                info = lives[index + 1]
            }
        }
        self.covers.append(info?.cover ?? self.liveInfo.cover)
    }
    private func locationWithScrollView(scrollView:UIScrollView) -> Location {
        let offSetY = scrollView.contentOffset.y
        if offSetY <= UIScreen.height / 2 {
            return .top
        }
        if offSetY >= UIScreen.height / 2 * 3 {
            return .bottom
        }
        else {
            return .middle
        }
    }
    func setThreeCoverImage() {
        if self.covers.count != 3 {
            return
        }
        self.topCoverView.kf.setImage(with: URL(string: self.covers.first ?? ""))
        self.middleCoverView.kf.setImage(with: URL(string: self.covers[1] ))
        self.bottomCoverView.kf.setImage(with: URL(string: self.covers[2] ))
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let location = self.locationWithScrollView(scrollView: scrollView)
        if location != .middle {
            self.sortImageAndShowModelDidEndDecelerating(location: location)
        }
        self.middleCoverView.isHidden = false
        scrollView.setContentOffset(CGPoint(x: 0, y: UIScreen.height), animated: false)
        self.setThreeCoverImage()
        self.change?(self.oldInfo ?? self.liveInfo,self.liveInfo)
    }
}

