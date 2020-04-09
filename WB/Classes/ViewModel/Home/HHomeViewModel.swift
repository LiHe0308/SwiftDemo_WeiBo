//
//  HHomeViewModel.swift
//  WB
//
//  Created by 李贺 on 2020/4/4.
//  Copyright © 2020 Heli. All rights reserved.
//  这是对应 HomeVc 的ViewModel, 处理网络请求和其他.

import UIKit
import Kingfisher

class HHomeViewModel: NSObject {

    // 处理首页数据的 HStatusViewModel数组
    lazy var statusViewmodelArray: [HStatusViewModel] = [HStatusViewModel]()
}

// MARK: 获取首页数据
extension HHomeViewModel {

    /// 获取首页数据
    /// - Parameters:
    ///   - isPullup: true 上拉操作; false 下拉操作
    ///   - isSuccess: 是否请求成功
    func getHomeData(isPullup: Bool, isSuccess:@escaping (Bool, Int)->()) {
        
        var since_id: Int64 = 0
        var max_id: Int64 = 0
        
        if isPullup {
            max_id = Int64(statusViewmodelArray.last?.homeModel?.id ?? 0)
            if max_id > 0 {
                max_id = max_id - 1
            }
        } else {
            since_id = Int64(statusViewmodelArray.first?.homeModel?.id ?? 0)
        }
        
        HNetworkTools.shared.getHomeData(since_id: since_id, max_id: max_id, success: { (response) in
            
            guard let res = response as? [String :Any] else{
                isSuccess(false, 0)
                return
            }
            
            guard let r = res["statuses"] else {
                isSuccess(false, 0)
                return
            }
            
            // 创建临时数组
            var tempArray: [HStatusViewModel] = [HStatusViewModel]()
            
            // MARK: - 创建调度组: 等待所有单张图片的下载任务都结束了, 才能刷新数据
            let group = DispatchGroup()
            
            for dict in (r as! [Any]) {
                
                // 字典转模型
                let model = HHomeModel(JSON: dict as! [String: Any])
            
    // MARK: - 判断原创微博的pic_urls.count 是否等于1, 如果等于一, 就下载该图片
                if model?.pic_urls?.count == 1 {
                    
                    // 进入调度组
                    group.enter()
                    // 使用 Kingfisher 下载
                    ImageDownloader.default.downloadImage(with: URL(string: model?.pic_urls?.first?.thumbnail_pic ?? "")!, retrieveImageTask: nil, options: [], progressBlock: nil) { (image, error, _, _) in
                        print("下载原创微博单张图片完成")
                        // 离开调度组
                        group.leave()
                    }
                }
                
    // MARK: - 判断转发微博的pic_urls.count 是否等于1, 如果等于一, 就下载该图片
                if model?.retweeted_status?.pic_urls?.count == 1 {
                
                    // 进入调度组
                    group.enter()
                    // 使用 Kingfisher 下载
                    ImageDownloader.default.downloadImage(with: URL(string: model?.retweeted_status?.pic_urls?.first?.thumbnail_pic ?? "")!, retrieveImageTask: nil, options: [], progressBlock: nil) { (image, error, _, _) in
                        print("下载转发微博单张图片完成")
                        // 离开调度组
                        group.leave()
                    }
                }
                
                // 创建处理数据的statusVM
                let statusViewModel = HStatusViewModel()
                // 为处理数据的statusVM 赋值
                statusViewModel.homeModel = model
                tempArray.append(statusViewModel)
            }
            
            if isPullup {
                // 上拉, 就把新得到的数据拼接在数组的后面
                self.statusViewmodelArray = self.statusViewmodelArray + tempArray
            } else {
                // 下拉, 就把新得到的数据插入在数组的前面
                self.statusViewmodelArray = tempArray + self.statusViewmodelArray
            }

    // MARK: 调度组接受所有下载任务完成的消息
            group.notify(queue: DispatchQueue.main) {
                // 回到主线程
                print("所有单张图片下载完成")
                // 单张图片都下载完毕, 才能刷新界面
                isSuccess(true, tempArray.count)
            }
            
            // 只要发送true消息了, 首页数据就会刷新, 所以下载所有单张配图, 要在这之前进行.
//            isSuccess(true)
        }) { (error) in
            isSuccess(false, 0)
            print(error.debugDescription)
        }
    }
}
