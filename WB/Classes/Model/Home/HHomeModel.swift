//
//  HHomeModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/4.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import ObjectMapper

class HHomeModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        created_at              <- map["created_at"]
        id              <- map["id"]
        text              <- map["text"]
        source              <- map["source"]
        user              <- map["user"]
        retweeted_status              <- map["retweeted_status"]
        pic_urls              <- map["pic_urls"]
    }
    
    /// 创建时间
    var created_at: String?{
        // Tue Apr 07 17:28:44 +0800 2020
        didSet{
            guard let time = created_at else {
                return
            }
            // 1.创建formatter
            let formatter = DateFormatter()
            // 2.设置时间的格式
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            // 3. 设置时间的区域(真机必须设置，否则可能不会转换成功)
            formatter.locale = Locale(identifier: "en")
            // 4.转换(转换好的时间是去除时区的时间) 2020-04-07 09:22:27 +0000
            let sinaDate = formatter.date(from: time)!

            //MARK: 处理微博时间
            /*
             - 业务逻辑介绍
                -如果是今年
                    - 如果是今天
                        - 如果当前时间和微博时间比较 赋值给s(秒数)
                        如果s <= 60 显示 刚刚
                        如果s > 60 && s <= 60*60 显示 x分钟前
                        如果 s > 60*60 显示 x小时前
                    - 如果是昨天
                        - 显示的格式为 昨天 HH:mm 例如 昨天 14:14
                    - 如果不是今天和昨天
                        - 显示的格式为 MM-dd HH:mm 例如 02-02 02:02
                -如果不是今年
                    - 显示的格式为 yyyy-MM-dd HH:mm  例如 2015-12-12 12:12
             */
            // 计算是否是今年
            let isThisYear = sinaDateisThisYear(sinaDate: sinaDate)
            // 是今年
            if isThisYear {
                // 日历类
                let calendar = Calendar.current
                // 今天
                if calendar.isDateInToday(sinaDate) {
                    // 计算出当前日期和微博日期的秒数差值 abs 绝对值
                    let s = abs(sinaDate.timeIntervalSinceNow)
                    // 刚刚
                    if s <= 60 {
                        timeString = "刚刚"
                    }else if s > 60 && s <= 60*60 {
                        // X分钟前
                        timeString = "\(Int(s/60))分钟前"
                    }else {
                        // X小时前
                        timeString = "\(Int(s/(60*60)))小时前"
                    }
                }else if calendar.isDateInYesterday(sinaDate){
                    // 昨天, 显示的格式为 昨天 HH:mm 例如 昨天 14:14
                    formatter.dateFormat = "昨天 HH:mm"
                    timeString = formatter.string(from: sinaDate)
                }else {
                    // 其他, 显示的格式为 MM-dd HH:mm 例如 02-02 02:02
                    formatter.dateFormat = "MM-dd HH:mm"
                    timeString = formatter.string(from: sinaDate)
                }
            }else {
                // 不是今年, 显示的格式为 yyyy-MM-dd HH:mm  例如 2015-12-12 12:12
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                print(formatter.string(from: sinaDate))
                timeString = formatter.string(from: sinaDate)
            }
        }
    }
    /// 微博id
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?{
        didSet{
            // "<a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>"
            guard let s = source, s.contains("\">"), s.contains("</") else {
                return
            }
            // 获取起始光标
            let start = s.range(of: "\">")
            // 获取结束光标
            let end = s.range(of: "</")
            // 截取中间结果 ( range -> idnex 就用lowerBound / upperBound)
            let result = String(s[start!.upperBound..<end!.lowerBound])
            sourceString = "来自: \(result)"
        }
    }
    /// 用户信息
    var user: HUserModel?
    /// 转发微博模型
    var retweeted_status: HHomeModel?
    /// 原创微博配图
    var pic_urls: [HPictureModel]?
    /// 微博来源拼接后的字符串
    var sourceString: String?
    /// 发布微博的时间(格式化好的)
    var timeString: String?
    
    // MARK: - 判断新浪微博的日期是否是今年
    func sinaDateisThisYear(sinaDate: Date) -> Bool{
        // 获取当前的日期
        let currentDate = Date()
        // 时间格式化
        let df = DateFormatter()
        // 指定格式
        df.dateFormat = "yyyy"
        // 通过当前的日期得到日期年的字符串
        let currentStr = df.string(from: currentDate)
        // 获取新浪微博的日期年的字符串
        let sinaStr = df.string(from: sinaDate)
        return currentStr == sinaStr
    }
}

/*
// 单一层级的可以使用 原生KVC 字典转模型 , 但是千万不能忘了objcMembers 或者(@objc)关键字!!!
@objcMembers
class HHomeModel: NSObject {
    
    /// 创建时间
    var created_at: String?
    /// 微博id
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
*/
