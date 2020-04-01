//
//  HNetworkTools.swift
//  WB
//
//  Created by 李贺 on 2020/3/31.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import Alamofire

/// Swift 中枚举不仅支持Int 类型, 还支持字符串和其它基本类型等
enum RequestMethod: String{
    case get = "get"
    case post = "post"
}

class HNetworkTools: NSObject {

    /// 定义全局的网络访问点
    static let shared: HNetworkTools = {
        let tools = HNetworkTools()
        return tools
    }()
    
    // MARK: 定义网络请求的公共方法
    func request(urlString: String, method: RequestMethod, parameters: Any?, success: @escaping (Any?)->(), failure: @escaping (Any?)->()) {
        
        Alamofire.request(urlString, method: getRequestMethod(method: method), parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in

            switch response.result {
            case .success(let json):
                success(json)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                failure(error)
            }
        }
    }
    
    // MARK: 获取网络请求方式
    private func getRequestMethod(method: RequestMethod) -> (HTTPMethod) {
        
        if method == .get {
            return HTTPMethod.get
        } else {
            return HTTPMethod.post
        }
    }
}
