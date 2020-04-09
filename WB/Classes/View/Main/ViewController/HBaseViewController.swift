//
//  HBaseViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/29.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HBaseViewController: UIViewController {

    // 记录用户是否登录的状态
    let isLogin: Bool = HOAuthViewModel.shared.isLogin
    
    // 访客视图: 定义成可选值, 在需要使用的地方, 再实例化
    var visitorView: HVisitorView?
    
    // 列表视图 - 登陆之后显示列表视图
    var tableView: UITableView = UITableView()

    /** loadView
     1. 什么时候被调用？
     - 每次访问UIViewController的view(比如controller.view、self..view)而且view为nil，loadView方法就会被调用。控制器的view是懒加载的，什么时候使用，什么时候才创建, 如果已经创建，怎么调用都不会再创建了。
     2. 作用：创建控制器的view
     3. loadView执行逻辑：
        -- 3.1 当前控制器是否从StoryBoard当中加载, 如果是，就加载storyboard中的view
        -- 3.2 有没有xib来描述控制器的view，如果有，就加载xib当中的view
        -- 3.3 如果都不是，就用UIView 创建一个
     4. loadView，viewDidLoad，viewDidUnload三者之间的联系
        - 4.1 第一次访问UIViewController的view时，view为nil，然后就会调用loadView方法创建view
        - 4.2 view创建完毕后会调用viewDidLoad方法进行界面元素的初始化
        - 4.3 当内存警告时，系统可能会释放UIViewController的view，将view赋值为nil，并且调用viewDidUnload方法
        - 4.4 当再次访问UIViewController的view时，view已经在3中被赋值为nil，所以又会调用loadView方法重新创建view
        - 4.5 view被重新创建完毕后，还是会调用viewDidLoad方法进行界面元素的初始化
     */
    override func loadView() {
        
        if isLogin {
            view = tableView
        } else {
            // 添加未登录的情况下的 导航栏按钮
            setupNav()
            // 实例化 visitorView
            visitorView = HVisitorView()
            view = visitorView
            visitorView?.closure = { [weak self] in
                // 这里是不管登录 注册 都走这个方法
                self?.loginButtonClick()
            }
        }
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: nil, title: "登录", target: self, action: #selector(loginButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: nil, title: "注册", target: self, action: #selector(loginButtonClick))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension HBaseViewController{
    
    // MARK: 登录/注册 都走这个方法
    @objc private func loginButtonClick() {
        print("登录-注册")
        // 模态形式弹出微博授权控制器 -> 带有导航条的vc
        let oauthVc = HOAuthViewController()
        let nav = HNavigationController(rootViewController: oauthVc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
