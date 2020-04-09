//
//  HomeBottomView.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HomeBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        // 添加三个等宽度的按钮
        let retweetButton = addChildButton(imageName: "timeline_icon_retweet", title: "转发")
        let commentButton = addChildButton(imageName: "timeline_icon_comment", title: "评论")
        let unlikeButton = addChildButton(imageName: "timeline_icon_unlike", title: "赞")
        retweetButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(commentButton)
        }
        commentButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(retweetButton.snp_right)
            make.width.equalTo(unlikeButton)
        }
        unlikeButton.snp_makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.left.equalTo(commentButton.snp_right)
        }
        
        // 添加两个竖线
        let line1 = addChildLine()
        let line2 = addChildLine()
        line1.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(retweetButton.snp_right)
        }
        line2.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(unlikeButton.snp_left)
        }
    }
}

extension HomeBottomView {
    
    // MARK: 添加底部按钮的公共方法
    private func addChildButton(imageName: String, title: String) -> UIButton {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), for: UIControl.State.highlighted)
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(.darkGray, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: HNORMALFONTSIZE)
        addSubview(btn)
        return btn
    }
    
    // MARK: 添加底部按钮中间竖线的公共方法
    private func addChildLine() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
        addSubview(imageView)
        return imageView
    }
}
