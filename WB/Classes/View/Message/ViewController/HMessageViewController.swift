//
//  HMessageViewController.swift
//  WB
//
//  Created by 李贺 on 2020/3/24.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HMessageViewController: HBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView?.setInfo(imageName: "visitordiscover_image_message", title: "登陆后, 最新、最热微博尽在掌握, 不会再与实事潮流擦肩而过")
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
