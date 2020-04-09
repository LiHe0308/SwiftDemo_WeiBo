//
//  HPictureModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//  配图模型

import UIKit
import ObjectMapper

class HPictureModel: Mappable{
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        thumbnail_pic   <- map["thumbnail_pic"]
    }
    
    var thumbnail_pic: String?
}
