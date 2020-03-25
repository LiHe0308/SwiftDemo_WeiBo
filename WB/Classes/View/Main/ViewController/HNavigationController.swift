//
//  HNavigationController.swift
//  WB
//
//  Created by 李贺 on 2020/3/25.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: 解决系统导航条下, 自定义左侧返回按钮导致拖拽屏幕左侧返回失效的问题
        interactivePopGestureRecognizer?.delegate = self
    }
    
    /** 自定义导航控制器 存在的问题
     -- 问题: 任何界面都支持拖拽屏幕左侧返回
     -- 描述: 当回到首页时, 拖拽屏幕, 造成屏幕右侧出现黑边, 再次点击push操作, 会卡顿等bug
     -- 解决: 将要接受到屏幕点击时, 判断是否为第一个控制器
     */
    // 将要接受手势点击
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if viewControllers.count == 1{
            return false
        }else{
            return true
        }
        
        // 可简写成
//        return viewControllers.count != 1
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 进入 二级 控制器
        if viewControllers.count > 0 {
            // 设置 返回标题
            var title = "返回"
            // 是第一层, 就显示主标题, 否则, 都显示返回
            if viewControllers.count == 1 {
                title = viewControllers.first?.title ?? ""
                // push 时 隐藏tab
                viewController.hidesBottomBarWhenPushed = true
            }
            
            // 设置 返回按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_back_withtext", title: title, target: self, action: #selector(popButtonClick))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popButtonClick() {
        popViewController(animated: true)
    }
}
