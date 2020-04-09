//
//  HUserModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import ObjectMapper

class HUserModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        screen_name            <- map["screen_name"]
        profile_image_url            <- map["profile_image_url"]
        verified            <- map["verified"]
        mbrank            <- map["mbrank"]
    }
    
    // 用户昵称
    var screen_name: String?
    // 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    // 是否是微博认证用户，-1 没有认证 , 1 认证用户, 2.3.5企业, 220达人
    var verified: Int = 0 {
        didSet{
            switch verified {
            case 1:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = UIImage(named: "avatar_vgirl")
            }
        }
    }
    // 会员等级
    var mbrank: Int = 0 {
        didSet{
            // 处理 会员等级对应的图片
            // 注: 在model/statusVm 来处理都可以(如果放到cell 赋值时处理就会多次调用, 影响性能)
            if mbrank >= 1 && mbrank <= 6 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            } else {
                mbrankImage = UIImage(named: "common_icon_membership")
            }
        }
    }
    // 会员等级对应的图片
    var mbrankImage: UIImage?
    
    // 认证对应的图片
    var verifiedImage: UIImage?
}
