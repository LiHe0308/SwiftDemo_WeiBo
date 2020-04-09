//
//  HomeOriginalView.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//  首页homeCell 的第一模块 -> 原创微博view

import UIKit
import SnapKit

class HomeOriginalView: UIView {

    // MARK: 记录 原创视图 底部约束
    private var originalViewBottomConstraint: Constraint?
    
    // view 对应的vm 来为view 赋值
    var statusModel: HStatusViewModel?{
        didSet{
            iconImageView.set_Image(image: statusModel?.homeModel?.user?.profile_image_url)
            nameLabel.text = statusModel?.homeModel?.user?.screen_name
            contentLabel.text = statusModel?.homeModel?.text
            membershipImageView.image = statusModel?.homeModel?.user?.mbrankImage
            avatarImageView.image = statusModel?.homeModel?.user?.verifiedImage
            
            // MARK: - 根据pic_urls 来判断是否有配图
            // MARK: 赋值之前, 卸载约束
            originalViewBottomConstraint?.deactivate()
            
            if let picUrls = statusModel?.homeModel?.pic_urls, picUrls.count > 0{
                print("有配图")
                /**
                 - 显示配图
                 - 为pictureView 赋值
                 - 更新自身(原创视图)底部约束 : 原创微博.bottom == 配图视图.bottom + 10
                 */
                pictureView.isHidden = false
                pictureView.picUrls = picUrls
                self.snp_makeConstraints { (make) in
                    originalViewBottomConstraint = make.bottom.equalTo(pictureView.snp_bottom).offset(10).constraint
                }
            } else {
                print("没有配图")
                /**
                 - 隐藏配图
                 - 更新自身(原创视图)底部约束 : 原创微博.bottom == 正文内容.bottom + 10
                 */
                pictureView.isHidden = true
                self.snp_makeConstraints { (make) in
                    originalViewBottomConstraint = make.bottom.equalTo(contentLabel.snp_bottom).offset(10).constraint
                }
            }
            
            // 来源
            sourceLabel.text = statusModel?.homeModel?.sourceString
            // 发布时间
            timeLabel.text = statusModel?.homeModel?.timeString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(iconImageView)
        iconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(iconImageView.snp_top)
        }
        
        addSubview(membershipImageView)
        membershipImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp_centerY)
            make.left.equalTo(nameLabel.snp_right).offset(10)
        }
        
        addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_left)
            make.bottom.equalTo(iconImageView.snp_bottom)
        }
        
        addSubview(sourceLabel)
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.bottom.equalTo(iconImageView.snp_bottom)
        }
        
        addSubview(avatarImageView)
        avatarImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp_right)
            make.centerY.equalTo(iconImageView.snp_bottom)
        }
        
        addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(KSCREENWIDTH - 20)
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
        }
        
        addSubview(pictureView)
        pictureView.backgroundColor = self.backgroundColor
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            // MARK: 控制台打印约束错误: 'UIView-Encapsulated-Layout-Height'
            // MARK: 原因: CollectionView为你的自定义View自动添加了其他约束
            // MARK: 解决办法: 设置优先级 priority
            // 配图的size, 要在自己的内部根据图片张数来自己设置, 但是pictureView 中的update方法会提示找不到需要更新的约束, 所以这里没有注释掉.
            make.size.equalTo(CGSize(width: 0, height: 0)).priorityLow()
        }
        
        self.snp_makeConstraints { (make) in
            originalViewBottomConstraint = make.bottom.equalTo(pictureView.snp_bottom).offset(10).constraint
        }
    }
    
    // MARK: 懒加载控件
    // 头像
    private lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_default"))
    
    // 昵称
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: HNORMALFONTSIZE)
        lab.textColor = .black
        return lab
    }()
    
    // 会员等级
    private lazy var membershipImageView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    // 时间
    private lazy var timeLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: HSMALLFONTSIZE)
        lab.textColor = THEMECOLOR
        return lab
    }()
    
    // 来源
    private lazy var sourceLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: HSMALLFONTSIZE)
        lab.textColor = THEMECOLOR
        return lab
    }()
    
    // 认证
    private lazy var avatarImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
    
    // 正文
    private lazy var contentLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: HNORMALFONTSIZE)
        lab.textColor = .black
        lab.numberOfLines = 0
        return lab
    }()
    
    // 配图
    private var pictureView: HomeOriginalPictureView = HomeOriginalPictureView()
}
