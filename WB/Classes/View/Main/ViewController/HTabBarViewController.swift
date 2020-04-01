//
//  HTabBarViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 自定义的HTabBar
        let tabBar = HTabBar()
        // 学习KVC构造函数时, 了解到key就是该类的属性名称,  多以这里对UITabBarController的只读属性tabBar -> 通过KVC 对私有属性赋值
        setValue(tabBar, forKey: "tabBar")
        tabBar.closure = {
            print("plus button click \(#function)")
        }
        
        addChild(HHomeViewController(), title: "首页", ImageName: "tabbar_home")
        addChild(HMessageViewController(), title: "消息", ImageName: "tabbar_message_center")
        addChild(HDiscoverViewController(), title: "发现", ImageName: "tabbar_discover")
        addChild(HMineViewController(), title: "我", ImageName: "tabbar_profile")
    }
}

// MARK: 可以把 extension 修饰的 类 放到任意一个地方去都可以, 但是要保证 里面的方法没有被 私有关键字 修饰即可.
extension HTabBarViewController{

    // addChild(_ childController: UIViewController) 是系统原有的方法, 和下面写的只是参数不同,  所以叫重载构造函数!
    // 当方法的参数的外部参数为占位符( _ )的时候, 调用该方法的时候就只显示你传入的数据, 其他的什么也不显示, 且( _ )可以删除, 删除之后再调用就和正常的参数一样显示参数名称了
    private func addChild(_ childController: UIViewController, title: String, ImageName: String) {

        // 设置标题
        //        childController.navigationItem.title = title
        //        childController.tabBarItem.title = title
        childController.title = title  // 只设置这一句完全等价上两句
        
        // 修改tabBar - title的颜色
        // iOS13 出现的问题: TabBar文字选中颜色Push一个页面，在pop回来之后就变成系统的蓝色的
        // 解决: 直接设置 tabBar 的 tintColor
//        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: THEMECOLOR], for: UIControl.State.selected)

        // 设置图片 - withRenderingMode 修改图片的渲染方式
        childController.tabBarItem.image = UIImage(named: ImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: "\(ImageName)_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        // 为tabBar添加子控制器 - 使用自定义导航控制器
        addChild(HNavigationController(rootViewController: childController))
    }
}

