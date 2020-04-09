//
//  HomeOriginalPictureView.swift
//  WB
//
//  Created by 李贺 on 2020/4/5.
//  Copyright © 2020 Heli. All rights reserved.
//  原创微博 配图视图
/**
 单张配图的特殊需求
    - 当配图仅为1张时
        - 图片宽度 <80 , 那么就显示80, >80 是多大就显示多大
        - 图片高度 >150 ,  那么就显示150,  <150 是多大就显示多大
 -  解决思路: 只有将网络图片下载到本地, 才能知道它的大小, 所以在 homeViewModel 中进行所有单张图片的下载.
 */

import UIKit
import Kingfisher

// 图片与两侧的举例
private let bothSides: CGFloat = 10.0
// 图片与图片间的举例
private let space: CGFloat = 5.0
// 计算图片的宽高
private let itemWH: CGFloat = (KSCREENWIDTH - 2*bothSides - 2*space) / 3.0

private let PICTURECELLID: String = "PICTURECELL_ID"

class HomeOriginalPictureView: UICollectionView {

    /**
     - 定义一个属性, 外界传递配图集合
     */
    var picUrls: [HPictureModel]? {
        didSet{
            
            let size = dealPictureSize(count: picUrls?.count ?? 0)
            self.snp_updateConstraints { (make) in
                make.size.equalTo(size).priorityLow()
            }
        
            // MARK
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            if picUrls?.count == 1{
                
                layout.itemSize = size
            } else {
                layout.itemSize = CGSize(width: itemWH, height: itemWH)
            }
            // 刷新
            reloadData()
        }
    }
    
    // MARK: 通过图片的张数, 来计算配图视图(HomeOriginalPictureView)的size
    func dealPictureSize(count: Int) -> CGSize {
    // MARK: 这里是单张图片, 计算size 的逻辑
        if count == 1 {
            // 获取到本地下载的图片(通过Kingfisher 下载的, 取的话也用Kingfisher)
            if let urlString = picUrls?.first?.thumbnail_pic {
    
                let image = ImageCache.default.retrieveImageInDiskCache(forKey: urlString)
                
                if let img = image {
                    // 得到本地图片的大小
                    var imageW = img.size.width
                    var imageH = img.size.height
                    
                    if imageW < CGFloat(80) {
                        imageW = 80
                    }
                    
                    if imageH > CGFloat(150) {
                        imageH = 150
                    }
                    return CGSize(width: imageW, height: imageH)
                }
            }
        }
        
    // MARK: 下面是多张图片计算size 的逻辑
        // 1. 获取每张图片的宽高(一行三张图片, 且为正方形)
        // 已经抽取到顶部了
        
        // 2. 通过图片张数, 获得行列
        // 列
        let row: Int = count == 4 ? 2 : count > 3 ? 3 : count
        // 行
        let clo: Int = count == 4 ? 2 : (count - 1) / 3 + 1
        
        // 3. 计算配图视图(HomeOriginalPictureView)的sizi
        let w = CGFloat(row)*itemWH + CGFloat(row - 1)*space
        let h = CGFloat(clo)*itemWH + CGFloat(clo - 1)*space
        return CGSize(width: w, height: h)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 自定义的layout
        let picLayout = UICollectionViewFlowLayout()
        picLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        picLayout.minimumLineSpacing = space
        picLayout.minimumInteritemSpacing = space
        super.init(frame: frame, collectionViewLayout: picLayout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        // 设置数据源代理
        dataSource = self
        // 注册cell
        register(HOriginalPictureCell.self, forCellWithReuseIdentifier: PICTURECELLID)
    }
}

extension HomeOriginalPictureView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PICTURECELLID, for: indexPath) as! HOriginalPictureCell
        cell.pic_url = picUrls![indexPath.item]
        return cell
    }
}


// MARK: 自定义HomeOriginalPictureView 的HOriginalPictureCell 展示图片
class HOriginalPictureCell: UICollectionViewCell {
    
    var pic_url: HPictureModel? {
        didSet{
            pictureImageView.set_Image(image: pic_url!.thumbnail_pic)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(pictureImageView)
        pictureImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    // 懒加载 imageView
    lazy var pictureImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "avatar_default_big"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
}
