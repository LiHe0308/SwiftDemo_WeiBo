//
//  HWelcomeViewController.swift
//  WB
//
//  Created by 李贺 on 2020/4/3.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HWelcomeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 界面已经显示时, 更新约束
        self.avatarImageView.snp_updateConstraints { (make) in
             make.top.equalTo(self.view).offset(100)
         }
        // 设置动画 - 阻尼动画
        /**
         withDuration: 动画时长
         delay: 延迟时间
         usingSpringWithDamping: 阻尼系数 (范围0~1, 值越小, 弹性效果越好)
         initialSpringVelocity: 起始系数
         options: 选项
         */
        UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            // 动画时 强行刷新UI
            self.view.layoutIfNeeded()
        }) { (isCompleted) in
            
            UIView.animate(withDuration: 0.25, animations: {
                self.nameLabel.alpha = 1
            }) { (isCompleted) in
                // 欢迎页动画 结束 -> 切换根控制器到首页
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CHANGEVC), object: "welcomeVc")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = RGB(r: 246, g: 246, b: 246, alpha: 0.85)
        view.addSubview(bgImageView)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        
        avatarImageView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 90))
            make.top.equalTo(self.view.snp_top).offset(450)
            make.centerX.equalTo(self.view)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(avatarImageView.snp_bottom).offset(16)
        }
    }
    
    // 懒加载背景图
    private lazy var bgImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "ad_background"))
        img.contentMode = .scaleAspectFit
        img.frame = self.view.bounds
        return img
    }()
    
    // 懒加载用户头像
    private lazy var avatarImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.borderColor = THEMECOLOR.cgColor
        img.layer.borderWidth = 1
        img.layer.cornerRadius = 45
        img.layer.masksToBounds = true
        img.set_Image(image: HOAuthViewModel.shared.userAccountModel?.avatar_large, placeholder: nil)
        return img
    }()
    // 懒加载用户昵称
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = .darkGray
        lab.textAlignment = .center
        lab.alpha = 0
        lab.text = HOAuthViewModel.shared.userAccountModel?.screen_name
        return lab
    }()
}
