//
//  HomeRetweetView.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import SnapKit

class HomeRetweetView: UIView {

    // MARK: 记录 原创视图 底部约束
    private var originalViewBottomConstraint: Constraint?
    
    // view 对应的vm 来为view 赋值
    var statusModel: HStatusViewModel? {
        didSet{
            contentLabel.text = statusModel?.homeModel?.retweeted_status?.text
            
            // MARK: - 根据pic_urls 来判断是否有配图
            // MARK: 赋值之前, 卸载约束
            originalViewBottomConstraint?.deactivate()
            
            if let picUrls = statusModel?.homeModel?.retweeted_status?.pic_urls, picUrls.count > 0{
                
                pictureView.isHidden = false
                pictureView.picUrls = picUrls
                self.snp_makeConstraints { (make) in
                    originalViewBottomConstraint = make.bottom.equalTo(pictureView.snp_bottom).offset(10).constraint
                }
            } else {

                pictureView.isHidden = true
                self.snp_makeConstraints { (make) in
                    originalViewBottomConstraint = make.bottom.equalTo(contentLabel.snp_bottom).offset(10).constraint
                }
            }
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
        
        // 转发微博界面 与访客视图界面背景色相同
        backgroundColor = RGB(r: 235, g: 235, b: 235)
        
        addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.equalTo(KSCREENWIDTH - 20)
        }
        
        addSubview(pictureView)
        pictureView.backgroundColor = self.backgroundColor
        pictureView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.size.equalTo(CGSize(width: 0, height: 0)).priorityLow()
        }
        
        self.snp_makeConstraints { (make) in
            originalViewBottomConstraint = make.bottom.equalTo(pictureView.snp_bottom).offset(10).constraint
        }
    }
    
    // 懒加载内容控件
    private lazy var contentLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: HNORMALFONTSIZE)
        lab.textColor = .darkGray
        lab.numberOfLines = 0
        return lab
    }()

    // 配图
    private var pictureView: HomeOriginalPictureView = HomeOriginalPictureView()
}
