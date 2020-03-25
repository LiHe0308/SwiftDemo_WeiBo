//
//  Ext+UIBarButtonItem.swift
//  WB
//
//  Created by 李贺 on 2020/3/25.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

// MARK: 为UIBarButtonItem 写extension
extension UIBarButtonItem {
    /** 构造便利函数 的 拓展
    -- UIBarButtonItem 可能有三种类型
        -- 纯图片
        -- 纯文字
        -- 图片 和 文字
     */
    // imageName: String? = nil 这种形式 就是参数为可选值 , 外界写不写该参数都可以, 且不写的话默认值为nil
    convenience init(imageName: String? = nil, title: String? = nil, target: Any?, action: Selector) {
        self.init()
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        
        // 因为传进来的imageName、title 均为可选值,
        // 所以需要使用 可选值判断 -> if let/var (注: 不用guard let/var 是因为判断完成之后, 其他参数还会有后续操作)
        if let img = imageName {
            button.setImage(UIImage(named: img), for: UIControl.State.normal)
            button.setImage(UIImage(named: "\(img)_highlighted"), for: UIControl.State.highlighted)
        }
        
        if let tit = title {
            button.setTitle(tit, for: UIControl.State.normal)
            button.setTitleColor(.darkGray, for: UIControl.State.normal)
            button.setTitleColor(THEMECOLOR, for: UIControl.State.highlighted)
        }
        button.sizeToFit()
        
        // 注: 在外界创建 UIBarButtonItem 的时候是这样赋值的, 所以在这直接为 customView 赋值
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        customView = button
    }
}
