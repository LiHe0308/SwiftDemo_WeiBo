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
        
        // 配置公共信息
        Alamofire.SessionManager.default.adapter = MyAdapter()
        
        Alamofire.request(urlString, method: getRequestMethod(method: method), parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in

            switch response.result {
            case .success(let json):
                print("json: \(json)")
                success(json)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                failure(error)
            }
        }.validate { (request, response, data) -> Request.ValidationResult in
            
            print("validate中的response: \(response)")
            guard let _ = data else {
                return .failure(NSError(domain: "没有数据", code: 9999, userInfo: nil))
            }
            if response.statusCode == 404 {
                return .failure(NSError(domain: "系统繁忙", code: response.statusCode, userInfo: nil))
            }
            return .success
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

// MARK: OAuth 网络请求相关
extension HNetworkTools {
    
    /// 获取授权信息(access_token) -> 去开放平台OAuth2.0 授权中看需要的参数和结果
    func getUserAccount(code: String, success: @escaping (Any?)->(), failure: @escaping (Any?)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = [
            "client_id": APPKEY,
            "client_secret": APPSECRET,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": REDIRECT_URI
        ]
        request(urlString: urlString, method: RequestMethod.post, parameters: parameters, success: { (res) in
            success(res)
        }) { (err) in
            failure(err)
        }
    }
    
    /// 获取用户信息
    func getUserInfo(model: HUserAccountModel,  success: @escaping (Any?)->(), failure: @escaping (Any?)->()) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parameter = [
            "access_token": model.access_token!,
            "uid": Int(model.uid!)!
        ] as [String: Any]
        request(urlString: urlString, method: .get, parameters: parameter, success: { (res) in
            success(res)
        }) { (err) in
            failure(err)
        }
    }
}
