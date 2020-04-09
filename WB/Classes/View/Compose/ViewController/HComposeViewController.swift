//
//  HComposeViewController.swift
//  WB
//
//  Created by 李贺 on 2020/4/8.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit

class HComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = HRandomColor()
    }
}
