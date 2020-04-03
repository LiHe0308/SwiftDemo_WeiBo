//
//  Ext+UIImageView.swift
//  WB
//
//  Created by 李贺 on 2020/4/3.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

/**
- 目前kf 提供两种加载网络图片的pai
 - kf.setImage(with: <#T##Resource?#>)
 - kf.setImage(with: <#T##Resource?#>, placeholder: <#T##Placeholder?#>, options: <#T##KingfisherOptionsInfo?#>, progressBlock: <#T##DownloadProgressBlock?##DownloadProgressBlock?##(Int64, Int64) -> Void#>, completionHandler: <#T##CompletionHandler?##CompletionHandler?##(Image?, NSError?, CacheType, URL?) -> Void#>)
 */
extension UIImageView{
    /// 获取网络图片的方法, image传网络图片的地址, placeholder传图片名称
    func set_Image(image: String?, placeholder: String? = nil) {
        
        guard let img = image else {
            print("图片资源不存在")
            return
        }
        
        let url = URL(string: img)
        guard let u = url else {
            print("图像路径转url失败")
            return
        }
        
        if let p = placeholder {
            
            kf.setImage(with: u, placeholder: UIImage(named: p), options: [], progressBlock: nil, completionHandler: nil)
            return
        }
        
        kf.setImage(with: u)
    }
}
