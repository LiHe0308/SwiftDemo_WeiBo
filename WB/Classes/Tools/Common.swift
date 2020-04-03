//
//  Common.swift
//  WB
//
//  Created by 李贺 on 2020/3/25.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
/**
 Swift 中所有文件全局共享, 没有 PCH 文件(类似于 OC 的.pch问价)
 */
// MARK: 屏幕尺寸相关
let KSCREENBOUNDS = UIScreen.main.bounds
let KSCREENWIDTH = KSCREENBOUNDS.width
let KSCREENHEIGHT = KSCREENBOUNDS.height

/// app 主题颜色
let THEMECOLOR = UIColor.orange
/// RGB 颜色
func RGB(r: Float, g: Float, b: Float, alpha: Float = 1) -> UIColor {
    return UIColor(red: CGFloat(r/Float(255)), green: CGFloat(g/Float(255)), blue: CGFloat(b/Float(255)), alpha: CGFloat(alpha))
}
/// 随机色
func HRandomColor() -> UIColor {
    let r = Float(arc4random() % 256)
    let g = Float(arc4random() % 256)
    let b = Float(arc4random() % 256)
    return RGB(r: r, g: g, b: b)
}

// 通知需要的名称
/// 登陆成功
let CHANGEVC = "NoticeOfSuccessfulLogin"
