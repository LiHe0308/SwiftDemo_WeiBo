//
//  RefreshControl.swift
//  CustomRefreshControl
//
//  Created by 李贺 on 2020/4/7.
//  Copyright © 2020 Heli. All rights reserved.
//
/**
 - 自定义下拉刷新控件分析
    - 使用什么自定义?
        - UIControl
    - 添加到谁身上?
        - 列表页上(UITableView 等)
    - 控件的Y 轴
        - 负的控件高度
    - 自定义刷新控件有三种状态
        - 正常中
        - 下拉中
        - 刷新中
    - 如何知道当前控件处于什么状态?(状态在滑动列表的时候就改变了)
    - 通过监听列表的偏移量, 来改变控件所处的状态
        - ContentOffset.Y
        - 在RefreshControl 中监听ContentOffset.Y 的变化
        - 也就是说在RefreshControl 监听UITableView 的ContentOffset.Y 变化, 实现手段:
            - 代理 -> 否定 (因为代理是一对一的, 多处同时需要使用RefreshControl 时, 就会出现混乱)
            - KVO -> 可以 (一对多)
 
 - 关于偏移量的问题分析 (越往下拉, ContentOffset.Y 越来越小, ContentOffset.Y 的绝对值越来越大)
    - 如果 y >= 负的(导航栏高度 + RefreshControl 自身的高度) -> 代表正常中
    - 如果 y < 负的(导航栏高度 + RefreshControl 自身的高度) -> 代表又继续下拉了 , 也就是下拉中, 此时
        - 用户松手了, 那就变成刷新中.
        - 用户没松手 -> 恢复成 下拉中 -> 正常中
    - 逻辑优化: 判断用户是都在拖动列表, 并且是否松手
        - 如果没有松手
            - 状态为 正常中 或者 下拉中
                - y >= 负的(导航栏高度 + RefreshControl 自身的高度) -> 正常状态
                - y < 负的(导航栏高度 + RefreshControl 自身的高度) -> 下拉状态
        - 如果松手
            - 如果状态为下拉中  -> 刷新中
 */
import UIKit

// 抽取刷新控件的高度
private let RefreshControlHeight: CGFloat = 50
// 刷新控件当前的状态类型
enum RefreshControlType: String {
    case normal = "正常中"
    case pulling = "下拉中"
    case refreshing = "刷新中"
}

class RefreshControl: UIControl {
    
    // MARK: - 提供给外界调用, 结束刷新动画
    func endRefreshing() {
        // 修改刷新状态 为 正常中
        refreshType = .normal
    }
    
    // MARK: - 记录列表(superView)
    private var scrollView: UIScrollView?
    
    // MARK: - 实时记录刷新控件的状态
    private var refreshType: RefreshControlType = .normal{
        didSet{
            
            DispatchQueue.main.async {
                
                // MARK: 通过枚举名称获得枚举值
                self.tipsLabel.text = self.refreshType.rawValue
                
                switch self.refreshType {
                case .normal:
                    // print("正常中")
                    // 修改下拉箭头朝向 -> 恢复原状
                     UIView.animate(withDuration: 0.25, animations: {
                        self.arrowImageView.transform = CGAffineTransform.identity
                     }) { (_) in
                         
                     }
                    // 判断refreshType 上一个状态是否为refreshing
                    if oldValue == .refreshing {
                        
                        // 停止loading动画, 显示箭头
                        self.indicatorView.stopAnimating()
                        self.arrowImageView.isHidden = false
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            self.scrollView!.contentInset.top = self.scrollView!.contentInset.top - RefreshControlHeight
                        }) { (_) in
                            
                        }
                    }
                case .pulling:
                    // print("下拉中")
                    // 修改下拉箭头朝向 -> 由下朝上
                    UIView.animate(withDuration: 0.25, animations: {
                        self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }) { (_) in
                        
                    }
                case .refreshing:
                    // print("刷新中")
                    
                    // 隐藏箭头, 开启loading动画
                    self.arrowImageView.isHidden = true
                    self.indicatorView.startAnimating()
                    
                    // 在动画中设置顶部inset 否则会特别生硬, 注释掉看效果即可.
                    UIView.animate(withDuration: 0.25, animations: {
                        self.scrollView!.contentInset.top = self.scrollView!.contentInset.top + RefreshControlHeight
                    }) { (_) in
                        // 动画结束, 告知外界开始刷新数据 (UIControl 的方法, 外界注册addTarget, Event 相同就能获取到事件)
                        self.sendActions(for: UIControl.Event.valueChanged)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -RefreshControlHeight, width: UIScreen.main.bounds.width, height: RefreshControlHeight))
        setupUI()
    }
    
    // MARK: 监听当前对象将要加载到父控件上
    override func willMove(toSuperview newSuperview: UIView?) {
        // 判断newSuperview 不为nil, 且能够滚动
        guard let scrollView = newSuperview as? UIScrollView else { return }
        
        // 赋值全局变量
        self.scrollView = scrollView
        
        // KVO 监听scrollView 的contentOffset 属性变化
        // 1. 注册KVO - 监听新值(NSKeyValueObservingOptions.new)变化
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    // 2. 观察者中实现的方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 这两个打印结果相同 , 也就表示change 中就是监听的结果
        // print(change?[NSKeyValueChangeKey(rawValue: "new")] as Any)
        // print(self.scrollView!.contentOffset.y)
        
        // 定义偏移临界值
        let criticalValue = -(RefreshControlHeight + CGFloat(NaviHeight))
        
        // 定义下拉偏移的大小
        let contentOffsetY = self.scrollView!.contentOffset.y
        
        // 判断用户是否在拖动中
        if self.scrollView!.isDragging {
            
            // 拖动中
            if contentOffsetY >= criticalValue && refreshType == .pulling {
                // 当 偏移量 >= 临界值, 代表向下拉的距离没超过临界值, 且当前状态为 下拉中, 这是要切换状态为 -> 正常中
                refreshType = .normal
            } else if contentOffsetY < criticalValue && refreshType == .normal {
                // 当 偏移量 < 临界值, 代表向下拉的距离更大, 且当前状态为 正常中, 这是要切换状态为 -> 下拉中
                refreshType = .pulling
            }
        } else{
            // 没有拖动, 也就是松手了
            // 只关心 刷新状态为下拉中时 松开手 , 此时切换状态为 刷新中
            if refreshType == .pulling {
                refreshType = .refreshing
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = .orange
        
        // 添加控件
        addSubview(tipsLabel)
        addSubview(arrowImageView)
        addSubview(indicatorView)
        
        // 设置约束 (注: 原生约束千万要加 translatesAutoresizingMaskIntoConstraints, 否则会有autoresize 生成的constraints , 导致冲突, 也就是代码设置的约束不管用了.)
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: tipsLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipsLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
         addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -35))
         addConstraint(NSLayoutConstraint(item: indicatorView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
    }
    
    // MARK: 懒加载控件
    // 提示label
    private lazy var tipsLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .center
        lab.text = "正常中"
        return lab
    }()
    
    // 上下拉 箭头ImageView
    private lazy var arrowImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    
    // 刷新时的 loading
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // 3. 移除KVO
        self.scrollView!.removeObserver(self, forKeyPath: "contentOffset")
    }
}
