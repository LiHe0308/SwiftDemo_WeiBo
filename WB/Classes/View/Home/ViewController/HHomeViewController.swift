//
//  HHomeViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HHomeViewController: HBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setInfo(imageName: nil, title: nil)
            return
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupNav()
    }
    
    // MARK: 创建导航栏的左右子控件
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch", target: self, action: #selector(leftButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonClick))
    }
}

extension HHomeViewController{
    
    @objc private func leftButtonClick() {
        print("左侧按钮点击")
    }
    
    @objc private func rightButtonClick() {
        print("右侧按钮点击")
        
        let tempVc = HTempViewController()
        navigationController?.pushViewController(tempVc, animated: true)
    }
}


