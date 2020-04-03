//
//  HOAuthViewModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/2.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HOAuthViewModel: NSObject {

    // 设置成单例模式, 减少外界初始化的代码量
    static var shared: HOAuthViewModel = HOAuthViewModel()
    
    // 个人信息对象 ,外界多处使用, 若直接调用getUesrAccountModel 方法, 就会多调用沙盒, 影响性能, 因次把个人信息设置成对象, 并且在HOAuthViewModel 初始化的时候赋值即可.
    var userAccountModel: HUserAccountModel?
    
    // 访问令牌
    var access_token: String? {
        // userAccountModel?.expires_date 比 Date() 是降序, 就代表前者比后者大, 即没过期
        if userAccountModel?.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            return userAccountModel?.access_token
        }else {
            // 过期了
            return nil
        }
    }
    
    // 是否登录 ->判断访问令牌是否过期
    var isLogin: Bool {
        return access_token != nil
    }
    
    override init() {
        super.init()
        // 给userAccountModel 赋值, 但是第一次登陆的时候还是为空 ->在31~32行解决了
        userAccountModel = getUesrAccountModel()
    }
}

// MARK: 保存和获取用户信息数据的模型, 提供给其他控制器使用
extension HOAuthViewModel {
    // 注意: extension终不能添加存储型(能读能写)属性, 所以即使存储模型的路径相同, 也不能拿到外面来定义
    
    /// 保存用户模型
    func saveUesrAccountModel(userAccountModel: HUserAccountModel) {
        // 解决第一次获取数据为nil 的bug
        self.userAccountModel = userAccountModel
        // 路径
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent("UserAccount.archiver")
        print("用户信息路径:\(filePath)")
        // 保存
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: userAccountModel, requiringSecureCoding: true)
            do {
                _ = try data.write(to: URL(fileURLWithPath: filePath))
                print("写入成功")
            } catch {
                print("data写入本地失败: \(error)")
            }
        } catch  {
            print("模型转data失败: \(error)")
        }
        
    }
    
    /// 获取用户模型
    func getUesrAccountModel() -> HUserAccountModel? {
        // 路径
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent("UserAccount.archiver")
        do {
            let data = try Data.init(contentsOf: URL(fileURLWithPath: filePath))
            // 当用户首次登陆, 直接从沙盒获取数据, 就会为nil  所以这里需要使用as?
            let model = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? HUserAccountModel
            return model
        } catch {
            print("获取data数据失败: \(error)")
            return nil
        }
    }
}

// MARK: 帮助OAuthVc 请求数据, 只需要告诉OAuthVc 是否成功即可.
extension HOAuthViewModel {
    // 登录流程: 先从webView 界面获取到code -> 获取授权得到access_token -> 获取用户信息代表登录成功
    func getUserAccount(code: String, isSuccess:@escaping (Bool)->()) {
        
        HNetworkTools.shared.getUserAccount(code: code, success: { (res) in
            
            // 判断res 是否为nil 而且是否为一个字典
            guard let r = res as? [String: Any] else {
                isSuccess(false)
                return
            }
            // 将字典转为userAccount 模型
            let userAccount = HUserAccountModel(JSON: r)
            // 判断模型是否为nil
            guard let u = userAccount else {
                isSuccess(false)
                return
            }
            self.getUserInfo(model: u, isSuccess: isSuccess)
        }) { (err) in
            isSuccess(false)
            print("获取access_token出现错误:\(err.debugDescription)")
        }
    }
    
    private func getUserInfo(model: HUserAccountModel, isSuccess:@escaping (Bool)->()) {
        
        HNetworkTools.shared.getUserInfo(model: model, success: { (res) in
            
            // 判断 res 是否为空, 并且是否为一个字典
            guard let r = res as? [String: Any] else {
                isSuccess(false)
                return
            }
            
            // 为model 赋值
            model.screen_name = r["screen_name"] as? String
            model.avatar_large = r["avatar_large"] as? String
            
            // 先保存信息, 再回调
            self.saveUesrAccountModel(userAccountModel: model)
            // MARK: 唯一返回 成功 点
            isSuccess(true)
        }) { (err) in
            isSuccess(false)
            print("获取用户信息出错: \(err.debugDescription)")
        }
    }
}
