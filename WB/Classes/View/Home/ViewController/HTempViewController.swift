//
//  HTempViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/25.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = HRandomColor()
        setupNav()
    }
    
    private func setupNav() {
        title = "第\(navigationController?.children.count ?? 0)个控制器"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: nil, title: "PUSH", target: self, action: #selector(pushButtonClick))
        
        // 系统的导航控制器 - 自定义了左侧返回按钮, 会使拖拽屏幕左侧返回的功能(iOS7.0)失效
        // 解决办法: 自定义导航控制器
        // 既然自定义了导航栏, 那么左侧返回按钮就在自定义的navVc中 动态设置了
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_back_withtext", title: nil, target: self, action: #selector(backButtonClick))
    }
}

extension HTempViewController{
    
    @objc private func pushButtonClick() {
        let tempVc = HTempViewController()
        navigationController?.pushViewController(tempVc, animated: true)
    }
    
    @objc private func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}
