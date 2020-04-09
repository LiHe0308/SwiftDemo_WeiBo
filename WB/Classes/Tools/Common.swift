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

/// 判断是否为刘海屏幕
@available(iOS 11.0, *)
func iPhoneXSeries() -> Bool{
    let insets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    return insets.bottom > CGFloat(0) ? true : false
}

/// 刘海高度
let AdaptNaviHeight = iPhoneXSeries() ? 24 : 0
/// 导航栏高度
let NaviHeight = iPhoneXSeries() ? 88 : 64
/// x 系列标签栏 底部横岗的高度
let AdaptTabHeight = iPhoneXSeries() ? 34 : 0
/// 标签栏高度
let TabBarHeight = iPhoneXSeries() ? 83 : 49

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

// 常用字体大小(小 普通 大)normal
let HSMALLFONTSIZE: CGFloat = 10
let HNORMALFONTSIZE: CGFloat = 14
let HLARGEFONTSIZE: CGFloat = 18

// 通知需要的名称
/// 登陆成功
let CHANGEVC = "NoticeOfSuccessfulLogin"
