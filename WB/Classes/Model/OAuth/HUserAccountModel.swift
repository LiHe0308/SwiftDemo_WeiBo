//
//  HUserAccountModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/1.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import ObjectMapper

class HUserAccountModel: NSObject, Mappable, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    // 从object 解析回来
    required init?(coder: NSCoder) {
        super.init()
        access_token = coder.decodeObject(forKey: "access_token") as? String ?? ""
        expires_in = coder.decodeObject(forKey: "expires_in") as? Double ?? 0
        uid = coder.decodeObject(forKey: "uid") as? String ?? ""
        screen_name = coder.decodeObject(forKey: "screen_name") as? String ?? ""
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String ?? ""
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String ?? ""
        expires_date = coder.decodeObject(forKey: "expires_date") as? Date
    }

    // 编码成object
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expires_in, forKey: "expires_in")
        coder.encode(uid, forKey: "uid")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")
        coder.encode(expires_date, forKey: "expires_date")
    }
    
    // 定义模型属性, 后台传输字段与系统关键词相关时, 直接自定义名称, 在mapping中修改就可以:nameId  <- map["id"]
    // 注意: 要严格的与后天传输类型相匹配, 否则得到的结果将为nil
    var access_token: String?
    // 设置 默认值 -> 也就是初始化 默认为0
    var expires_in: Double = 0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var uid: String?
    // 过期日期
    var expires_date: Date?
    
    // 用户名
    var screen_name: String?
    // 头像
    var avatar_large: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        access_token                        <- map["access_token"]
        expires_in                          <- map["expires_in"]
        uid                                 <- map["uid"]
        
        screen_name                         <- map["screen_name"]
        avatar_large                        <- map["avatar_large"]
    }
    
    /**
     重写description 方法, 方便模型打印
     注意: Swift中 """ XXX """,3个双引号的作用就是: 表示分行的作用，和\n的效果一样
     */
    override var description: String{
        let description =
        """
        {
        "access_token": "\(access_token ?? "NULL")",
        "expires_date": "\(expires_date)",
        "uid": "\(uid ?? "NULL")",
        "screen_name": "\(screen_name ?? "NULL")",
        "avatar_large": "\(avatar_large ?? "NULL")",
        }
        """
        return description
    }
    
    /**
     "access_token": "ACCESS_TOKEN",
     "expires_in": 1234,
     "remind_in":"798114",
     "uid":"12341234"
     */
}
