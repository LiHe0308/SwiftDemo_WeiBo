//
//  HMineViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HMineViewController: HBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
             visitorView?.setInfo(imageName: "visitordiscover_image_profile", title: "登陆后, 你的微博、相册、个人资料会显示在这里, 展示给别人看")
             return
         }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
