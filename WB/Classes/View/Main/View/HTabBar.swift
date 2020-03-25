//
//  HTabBar.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HTabBar: UITabBar {

    // 定义闭包传递加号按钮点击事件
    var closure: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置主题色 - 也就是 tabBar 上文字的颜色
        tintColor = THEMECOLOR
        setupUI()
    }
    
    // 只写了初始化方法, 会提示错误: 'required' initializer 'init(coder:)' must be provided by subclass of 'UITabBar'
    /** 点击提示可自动 fix
        -- 什么时候见过?  sb或者xib加载的时候, 解码的时候
        -- 如果继承UIView, 但是是采用纯代码开发项目时, 系统就会默认联想出 initWithCoder 方法
        -- 如果当前类被其他开发者作为 sb/xib 使用, 就会调用该方法, 表示该类不支持 sb/xib创建
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(plusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 所有添加到tabBar上的item都是subView
        // 因为item要均分, 所以计算子控件的宽度 一共五个
        let w = KSCREENWIDTH * 0.2
        // 确定子控件的位置
        var index: CGFloat = 0
        
        // 观察图层了解到, 被添加到tabBar上的item 为UITabBarButton类型, 所以遍历所有子控件, 找到在外界添加的item
        for view in subviews {
            
            // 判断类型是否为UITabBarButton (注: UITabBarButton为私有属性, .self获取不到该类型的class)
            if view .isKind(of: NSClassFromString("UITabBarButton")!) {
                
                // 重新设置item 的宽和x
                view.frame.size.width = w
                view.frame.origin.x = index * w
                
                index += 1
                
                // 给 加号按钮 预留出中心位置
                if index == 2 {
                    index += 1
                }
                
                // MARK: 这里会设置4次, 有待优化
                plusButton.center.y = view.center.y
            }
        }
        
        // 设置加号按钮的约束
        plusButton.center.x = frame.width * 0.5
    }

    // 懒加载 加号按钮
    private lazy var plusButton: UIButton = {
       
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControl.State.normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControl.State.highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControl.State.normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControl.State.highlighted)
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(buttonClick), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    /** @objc
     Swift       是静态语言, 编译的时候就知道谁调用谁了
     OC          是运行时语言, 是通过消息的运行循环来一层层找的
     
     在Swift4.0之后(包括4.0), 继承于 NSObject的 所有 Swift Class 不会在默认 bridge 到OC, 也就是没有告诉系统 Swift Class内容的存在, 所以会找不到
     
     解决办法:
     - 在当前类的每个属性前面 添加 @objc 关键字
     - 在当前类的最上方 添加 @objcMembers 关键字
    */
    
    /** private 和 fileprivate
     -- private 访问级别是最低和最严格的级别, 也就是说限制性最强
     -- private 所修饰的属性或者方法 只能在 当前类 里面进行访问, 对于不希望对外暴露的方法, 应该使用 private 关键字来修饰
     -- Swift3.0 如果 private 修饰的方法写在其类的 extension 中时, extension外则无法无访问, 若要访问需要修改成 fileprivate
     -- Swift4.0 之后 被 private 修饰的属性和方法, 只可以在该类下使用 (包括 extension 中, 因为是同类), 反之也可以
     -- 即使在同一文件夹下, 使用 private 修饰 不同类的属性和方法是不能调用的, 就算 继承 的话, 子类也无法调用
     -- fileprivate 修饰的话, 在同一定义的源文件(就是同一个.swift文件)中是可以相互调用的
     -- 异同: private 不能在 class 以外访问, 且必须是同类中，而 fileprivate 作用域是当前文件, 可以是不同类
     */
    @objc private func buttonClick() {
        closure?()
    }
}
