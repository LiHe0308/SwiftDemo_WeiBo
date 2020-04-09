//
//  HComposeModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/8.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

@objcMembers

class HComposeModel: NSObject {
    /// 图片名
    var icon: String?
    /// 文字
    var title: String?
    /// 自定义类的名称
    var classname: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
