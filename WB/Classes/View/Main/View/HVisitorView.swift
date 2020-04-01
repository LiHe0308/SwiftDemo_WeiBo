//
//  HVisitorView.swift
//  WB
//
//  Created by 李贺 on 2020/3/29.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 定义 闭包, 传递登录注册点击事件
    var closure: (()->())?
    
    open func setInfo(imageName: String?, title: String?) {
        
        if let img = imageName, let tit = title {
            iconImageView.image = UIImage(named: img)
            messageLabel.text = tit
            // 隐藏圆圈图片
            feedImageView.isHidden = true
        } else {
            // 首页 都传的 nil
            setFeedImageViewAnim()
        }
    }
    
    // 设置 首页圆圈图片做动画
    private func setFeedImageViewAnim() {
        // 核心动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置toValue
        anim.toValue = Double.pi * 2
        // 设置时长
        anim.duration = 20
        // 设置重复次数
        anim.repeatCount = MAXFLOAT
        // 默认是YES, 代表动画执行完毕后就从图层上移除, 图形就恢复到动画执行前的状态. 当切换控制器或者前后台时, 默认动画会被移除 -> 这里阻止这个操作
        anim.isRemovedOnCompletion = false
        // 添加动画
        feedImageView.layer.add(anim, forKey: nil)
    }
    
    // 注意: 添加约束的时候尽量不要写在layoutSubViews中, Swift会报错, 因为layoutSubViews会被多次调用, 所以多次添加约束, 就报错了. OC条件下是可以的.
    private func setupUI() {
        backgroundColor = RGB(r: 235, g: 235, b: 235)
        
        // 1. 添加背景图片
        addSubview(feedImageView)
        
        // 原生方法 设置图片约束
        /**
        1. 代码addSubview, 如果想使用相对布局, 记得要设置subView 的translatesAutoresizingMaskIntoConstraints 为false, 否则会有autoresize 生成的constraints , 导致冲突, 也就是代码设置的约束不管用了.
        2. 而在Interface Builder 中Use autoLayout, IB 生成的控件的translatesAutoresizingMaskIntoConstraints 自动就被置位false了.
        3. 第三方约束工具SnipKit 自动帮助我们设置了.
        */
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        /** addConstraints参数说明:
        参数1: 添加约束的对象
        参数2: 添加约束的对象的哪个属性
        参数3: 约束关系
        参数4: 设置约束参考的对象
        参数5: 设置约束参考的对象的哪个属性
        参数6: 倍数
        参数7: 偏移量
        */
        addConstraints([NSLayoutConstraint(item: feedImageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)])
        addConstraints([NSLayoutConstraint(item: feedImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)])
        
        // 2. 添加 半遮挡图片
        addSubview(maskImageView)
        // 使用第三方来设置约束
        maskImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        // 3. 添加小房子控件
        addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        // 4. 添加文字 信息
        addSubview(messageLabel)
        messageLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(maskImageView.snp_bottom).offset(16)
            make.width.equalTo(230)
        }
        
        // 添加登录按钮
        addSubview(loginButton)
        loginButton.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(35)
            make.left.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
        }
        
        // 添加注册按钮
        addSubview(registerButton)
        registerButton.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(35)
            make.right.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
        }
    }
    
    // MARK: 懒加载 圆圈图片控件
    private lazy var feedImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // MARK: 懒加载 半遮挡控件
    private lazy var maskImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    // MARK: 懒加载 小房子图片 控件
    private lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // MARK: 懒加载 底部说明 控件
    private lazy var messageLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = .darkGray
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.text = "关注一些人, 回这里看看有什么惊喜关注一些人, 回这里看看有什么惊喜"
        return lab
    }()
    // MARK: 懒加载 登录按钮 控件
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_white"), for: UIControl.State.normal)
        btn.setTitle("登录", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        btn.setTitleColor(THEMECOLOR, for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(leftBtnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    // MARK: 懒加载 注册按钮 控件
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "common_button_white"), for: UIControl.State.normal)
        btn.setTitle("注册", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        btn.setTitleColor(THEMECOLOR, for: UIControl.State.highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(rightBtnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
}

extension HVisitorView{
    
    @objc private func leftBtnClick() {
        closure?()
    }
    @objc private func rightBtnClick() {
        closure?()
    }
}
