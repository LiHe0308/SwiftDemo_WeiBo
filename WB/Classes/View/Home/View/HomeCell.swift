//
//  HomeCell.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//
/**
 homeCell   主要分为三部分
 1. 原创微博部分(必须有)
    - 用户信息
    - 配文(可有可无)
    - 配图(可有可无)
 2. 转发微博部分(可有可无)
    - 配文
    - 配图(可有可无)
 3. 底部视图(必须有)
    - 转发
    - 评论
    - 赞
 */

import UIKit
import SnapKit

class HomeCell: UITableViewCell {

    // MARK: 记录底部视图的 顶部约束 (需要引入import SnapKit)
    var bottomViewTopConstraint: Constraint?
    
    // view 对应的vm 来为view 赋值
    var statusModel: HStatusViewModel?{
        didSet{
            // 为原创微博赋值
            originalView.statusModel = statusModel
            // 判断是都有转发微博(retweeted_status 是否有值)
            
            // MARK: - 存在问题: 不管是否存在 转发微博view, 都会对 底部视图的 顶部约束 进行修改, 因为在setupUI 对底部视图已经做了约束, 所以下面直接修改约束的话, 会就报错(重复添加约束).
            
            // MARK: - 解决办法: 在setupUI 中记录底部视图需要变化的约束, 也就是底部视图的 顶部约束. 记录方式在29行,  赋值方式为在约束后面添加.constraint(96行)
            
            // MARK: - 注意: 每次重新对底部视图的顶部做约束时, 要把以前对底部视图的顶部的约束移除 ->卸载约束!
            bottomViewTopConstraint?.deactivate()
            
            if statusModel?.homeModel?.retweeted_status != nil {
                /**
                 - 有转发微博, 显示转发微博View
                 - 为转发微博赋值
                 - 修改底部视图的约束(bottomView.Top == retweetView.bottom)
                 */
                retweetView.isHidden = false
                retweetView.statusModel = statusModel
                bottomView.snp_makeConstraints { (make) in
                    // 由于cell 的缓存机制, 不知道从缓存池拿出来的约束是哪个样子的, 所以都加上记录. 方便下次进来的时候卸载.
                    bottomViewTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
                }
            } else {
                /**
                - 没有转发微博, 隐藏转发微博View
                - 修改底部视图的约束(bottomView.Top == originalView.bottom)
                */
                retweetView.isHidden = true
                bottomView.snp_makeConstraints { (make) in
                    bottomViewTopConstraint = make.top.equalTo(originalView.snp_bottom).constraint
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        // 1. 添加原创微博view
        contentView.addSubview(originalView)
        // 设置原创微博约束
        originalView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            // MARK: 原创微博高度约束 应该在自己内部实现
//            make.height.equalTo(60)
        }
        
        // 2. 添加转发微博view
        contentView.addSubview(retweetView)
        retweetView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(originalView.snp_bottom)
            // MARK: 转发微博高度约束 应该在自己内部实现
//            make.height.equalTo(150)
        }
        
        // 3. 添加底部view
        // MARK: cell 自适应高度, 需要与底部视图做约束(具体⬇️)
        contentView.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            // MARK: 记录底部视图的 顶部约束的赋值方式
            bottomViewTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
            make.height.equalTo(35)

            /** swift3.0 之后cell 的高度自适应
                写法1 - 直接设置最底部控件的底部与contentView的底部平齐
             */
            make.bottom.equalTo(contentView)
        }
        
        // swift3.0 之前通过这种方式来约束
//        contentView.snp_makeConstraints { (make) in
//            make.bottom.equalTo(bottomView)
//        }
        
        /** swift3.0 之后cell 的高度自适应
           写法2 - 设置contentView 的四边与self 相等, 底部与最底部控件平齐
           弊端: 控制台会打印约束的垃圾信息.
                Changing the translatesAutoresizingMaskIntoConstraints property of the contentView of a UITableViewCell is not supported and will result in undefined behavior, as this property is managed by the owning UITableViewCell
                (不支持更改UITableViewCell的contentView的translatesAutoresizingMaskIntoConstraints属性，这将导致未定义的行为，因为此属性由所属UITableViewCell管理)
        */
//        contentView.snp_makeConstraints { (make) in
//            make.left.top.right.bottom.equalTo(self)
//            make.bottom.equalTo(bottomView)
//        }
    }
    
    // 懒加载 原创微博view
    private lazy var originalView: HomeOriginalView = HomeOriginalView()
    // 懒加载 转发微博view
    private lazy var retweetView: HomeRetweetView = HomeRetweetView()
    // 懒加载 底部(转发、评论、赞)view
    private lazy var bottomView: HomeBottomView = HomeBottomView()
}
