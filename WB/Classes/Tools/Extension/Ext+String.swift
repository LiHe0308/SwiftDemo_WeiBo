//
//  Ext+String.swift
//  WB
//
//  Created by 李贺 on 2020/4/7.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

extension String {
    /**
     时间转化为时间戳
     */
    func stringToTimeStamp()->String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: self)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
    }
    /**
     时间戳转时间
     */
    func timeStampToString()->String {
        let string = NSString(string: self)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
}
