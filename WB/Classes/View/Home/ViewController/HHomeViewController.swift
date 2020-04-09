//
//  HHomeViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

// cell 可重用标识符
private let HOMECELLID: String = "HOMECELL_ID"

class HHomeViewController: HBaseViewController {
    
    // 懒加载 homeViewModel, 当用户已经登陆的情况下才创建对象
    lazy var homeViewModel: HHomeViewModel = HHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 未登录 ,加载访客视图
        if !isLogin {
            visitorView?.setInfo(imageName: nil, title: nil)
            return
        }
        
        // 将数据刷新完毕的提示框 插入在导航栏的navigationBar 之下
        navigationController?.view.insertSubview(pullDownTipsLabel, belowSubview: navigationController!.navigationBar)
        
        // 加载导航栏
        setupNav()
        // 加载列表信息
        setUITableViewInfo()
        // 获取数据
        getData()
    }

    // MARK: 懒加载控件
    // 自定义系统的loading -> 风火轮
    private lazy var footView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = THEMECOLOR
        return view
    }()
    // 系统下拉刷新控件
    private lazy var refreshControl: RefreshControl = RefreshControl()
    // 下拉刷新提示标签
    private lazy var pullDownTipsLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: HNORMALFONTSIZE)
        lab.backgroundColor = THEMECOLOR
        lab.frame = CGRect(x: 0, y: NaviHeight - 35, width: Int(KSCREENWIDTH), height: 35)
        lab.isHidden = true
        return lab
    }()
}

// MARK: 数据、动画相关
extension HHomeViewController {
    // MARK: 获取首页数据
    private func getData() {
        // 做动画就是上拉, 没做动画就是下拉或者第一次请求数据
        homeViewModel.getHomeData(isPullup: footView.isAnimating) { (isSuccess, count) in
            
            // MARK: 在结束动画之前调用, 因为在结束动画,footView.isAnimating == false 才证明是下拉刷新, 才会有动画
            if !self.footView.isAnimating {
                self.setPullDownTipsLabelAni(count: count)
            }
        
            self.stopAnimating()
            if isSuccess {
                self.tableView.reloadData()
            }else{
                print("获取首页数据失败")
            }
        }
    }
    
    // 结束刷新动画
    private func stopAnimating() {
        // 停止系统refreshControl 的动画
        self.refreshControl.endRefreshing()
        // 停止风火轮加载动画
        self.footView.stopAnimating()
    }
    
    // 设置pullDownTipsLabel 的动画 -> 下拉刷新才会弹出动画
    private func setPullDownTipsLabelAni(count: Int) {
        
        if !self.pullDownTipsLabel.isHidden {
            return
        }
        
        var text = ""
        if count > 0{
            text = "已经更新了\(count)条微博"
        } else {
            text = "已经是最新的微博了"
        }
        self.pullDownTipsLabel.text = text
        self.pullDownTipsLabel.isHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.pullDownTipsLabel.transform = CGAffineTransform(translationX: 0, y: 35)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
                self.pullDownTipsLabel.transform = CGAffineTransform.identity
            }) { (_) in
                self.pullDownTipsLabel.isHidden = true
            }
        }
    }
}

// MARK: UITableView & dataSource & delegate
extension HHomeViewController: UITableViewDelegate, UITableViewDataSource{

    // MARK: 设置UITableView 相关
    private func setUITableViewInfo() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCell.self, forCellReuseIdentifier: HOMECELLID)
        // 自动计算行高
        tableView.rowHeight = UITableView.automaticDimension
        // 设置预估行高
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 设置 tableFooterView(上拉加载视图)
        tableView.tableFooterView = footView
        
        // 直接添加至 tableView即可. 大小、位置会自动计算
        tableView.addSubview(refreshControl)
        // 监听事件
        refreshControl.addTarget(self, action: #selector(refreshAction), for: UIControl.Event.valueChanged)
    }
    
    // 监听refreshControl 下拉
    @objc private func refreshAction() {
        getData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.statusViewmodelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HOMECELLID, for: indexPath) as! HomeCell
        cell.statusModel = homeViewModel.statusViewmodelArray[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // MARK: 当cell将要展示vm 获取到的数据的最后一个, 并且footView 没有开始动画
        if homeViewModel.statusViewmodelArray.count - 1 == indexPath.row && !footView.isAnimating {
            // 开启动画
            footView.startAnimating()
            // 加载更多
            getData()
        }
    }
}

// MARK: 导航栏相关
extension HHomeViewController{
    // 创建导航栏的左右子控件
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch", target: self, action: #selector(leftButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonClick))
    }
    
    @objc private func leftButtonClick() {
        print("左侧按钮点击")
    }
    
    @objc private func rightButtonClick() {
        print("右侧按钮点击")
        
        let tempVc = HTempViewController()
        navigationController?.pushViewController(tempVc, animated: true)
    }
}


