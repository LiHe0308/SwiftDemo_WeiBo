//
//  MyAdapter.swift
//  WB
//
//  Created by 李贺 on 2020/4/2.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import Alamofire

// MARK: 遵守RequestAdapter 协议
class MyAdapter: RequestAdapter {

    // 实现adapt 协议方法, 来完成公共参数的配置
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        // 需要什么就设置什么
        request.setValue("device", forHTTPHeaderField: "iOS")
        request.setValue("vision", forHTTPHeaderField: "1.0.0")
        return request
    }
}
