//
//  Reactive+Extension.swift
//  School
//
//  Created by 冯龙飞 on 2019/9/23.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MJRefresh
public typealias RefreshHandler = (()->())
public enum RefreshState {
    case headerEndRefresh;
    case footEndRefresh;
    case noMoreData;
    case resetNoMoreData;
}
public extension UIScrollView {
    func addHeaderRefresh(handler:@escaping RefreshHandler) -> () {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: handler)
        let header = self.mj_header as? MJRefreshNormalHeader
        header?.lastUpdatedTimeLabel?.isHidden = true
    }
    func addFooterRefresh(handler:@escaping RefreshHandler) -> () {
        self.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: handler)
        self.autoShowFooter(hasData: false)
    }
    func startHeaderFresh() -> () {
        self.mj_header?.beginRefreshing()
    }
    func headerStopRefresh(){
        self.mj_header?.endRefreshing()
    }
    func footerStopRefresh(){
        self.mj_footer?.endRefreshing()
    }
    func footerNomoredata() {
        self.mj_footer?.endRefreshingWithNoMoreData()
    }
    func footerResetNoMoreData() {
        self.mj_footer?.resetNoMoreData()
    }
    func refreshHeader() -> MJRefreshNormalHeader? {
        return self.mj_header as? MJRefreshNormalHeader
    }
    func refreshFooter() -> MJRefreshAutoNormalFooter? {
        return self.mj_footer as? MJRefreshAutoNormalFooter
    }
    
    /// 自动隐藏Footer
    /// - Parameter hasData: 是否有数据
    func autoShowFooter(hasData:Bool = false)  {
        self.refreshFooter()?.stateLabel?.isHidden = !hasData
    }
}
public extension Reactive where Base: UIScrollView {
    var headerRefresh : ControlEvent<Void>{
        let source : Observable<Void> = Observable.create {[weak control = self.base ]  observe -> Disposable in
            if let control = control {
                control.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                    observe.onNext(())
                })
                let header = control.mj_header as? MJRefreshNormalHeader
                header?.lastUpdatedTimeLabel?.isHidden = true
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    var footerRefresh : ControlEvent<Void>{
        let source : Observable<Void>  = Observable.create{[weak control = self.base ] observe -> Disposable in
            if let control = control {
                
                control.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    observe.onNext(())
                })
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    var refreshResult : Binder<RefreshState>{
        return Binder(self.base){scrollview,result in
            switch result {
            case .headerEndRefresh:
                scrollview.mj_header?.endRefreshing()
            case .footEndRefresh:
                scrollview.mj_footer?.endRefreshing()
            case .noMoreData:
                scrollview.mj_footer?.endRefreshingWithNoMoreData()
            case .resetNoMoreData:
                scrollview.mj_footer?.resetNoMoreData()
            }
        }
    }
    
}

