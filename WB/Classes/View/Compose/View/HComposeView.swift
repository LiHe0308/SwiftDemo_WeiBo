//
//  HComposeView.swift
//  WB
//
//  Created by 李贺 on 2020/4/7.
//  Copyright © 2020 Heli. All rights reserved.
//

import UIKit
import pop

class HComposeView: UIView {
    
    // 保存六个按钮的数组
    var composeButtonsArray: [UIButton] = [UIButton]()
    // 记录自己的父控件
    var target: UIViewController?
    
    // MARK: - 供外界调用的方法, 将自己添加到父控件上, 添加完成, 按钮开始做动画
    func show(target: UIViewController){
        // 记录
        self.target = target
        // 添加到父控件上
        target.view.addSubview(self)
        // 设置6个按钮的动画
        setupComposeButtonsAnim(isUp: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 设置视图
    private func setupUI(){
        // 设置大小
        self.frame.size = CGSize(width: KSCREENWIDTH, height: KSCREENHEIGHT)

        // 添加子控件
        addSubview(bgImageView)
        addSubview(logoImageView)
        addChildButtons()
        
        // 设置约束
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }
    }

    // MARK: - 背景图片
    private lazy var bgImageView: UIImageView = {
        let img = UIImageView()
        img.image = screenShot()
        // 原生高斯模糊
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
        blur.frame = KSCREENBOUNDS
        img.addSubview(blur)
        
        return img
    }()
    
    // MARK: - logo
    private lazy var logoImageView: UIImageView = UIImageView(image: UIImage(named: "compose_slogan"))

    // MARK: - 创建6个按钮
    private func addChildButtons(){
        // 得到数组
        let composeModelArray = loadPlist()
        
        // 抽取按钮的宽和高度
        let buttonW: CGFloat = 80
        let buttonH: CGFloat = 110
        // 计算间距
        let buttonMargin = (KSCREENWIDTH - buttonW*3)/4
        
        // 遍历数组
        for (i, composeModel) in composeModelArray.enumerated() {
            // 实例化button
            let button =  HComposeButton()
            // 设置model
            button.composeModel = composeModel
            // 添加点击事件
            button.addTarget(self, action: #selector(composeButtonClick), for: .touchUpInside)
            // 设置size
            button.frame.size = CGSize(width: buttonW, height: buttonH)
            
            // 计算列和行的索引
            let colIndex = CGFloat(i%3)
            let rowIndex = CGFloat(i/3)
            // 设置x&y轴
            button.frame.origin.x = buttonMargin + colIndex*(buttonW + buttonMargin)
            // 在屏幕下方, 做动画再上来
            button.frame.origin.y = rowIndex*(buttonH + buttonMargin) + KSCREENHEIGHT
            // 设置image
            button.setImage(UIImage(named: composeModel.icon ?? ""), for: .normal)
            button.setTitle(composeModel.title, for: .normal)
            addSubview(button)
            // 添加六个按钮
            composeButtonsArray.append(button)
        }
    }
    
    // MARK: - 设置6个按钮的动画
    func setupComposeButtonsAnim(isUp: Bool){
        // 默认动画使用高度临界值
        var H:CGFloat = 350
        
        // 按钮消失  -> 逆序依次消失
        if !isUp {
            composeButtonsArray.reverse()
            H = -350
        }
        
        // 遍历保存按钮的数组 分别给六个按钮设置动画 -> 正序依次添加
        for (i, button) in composeButtonsArray.enumerated() {
            // 实例化阻尼动画对象 -> 变化中心点坐标
            let anSpring = POPSpringAnimation(propertyNamed: kPOPViewCenter)!
            // 设置终点位置
            anSpring.toValue = CGPoint(x: button.center.x, y: button.center.y - H)
            // 开始时间 CACurrentMediaTime() 系统绝对时间
            anSpring.beginTime = CACurrentMediaTime() + Double(i)*0.025
            //[0-20] 弹力 越大则震动幅度越大
            anSpring.springBounciness = 4
            //[0-20] 速度 越大则动画结束越快
            anSpring.springSpeed = 12
            // 给button按钮添加动画
            button.pop_add(anSpring, forKey: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6个按钮小时的动画
        setupComposeButtonsAnim(isUp: false)
        // 延迟移除当前的view
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.removeFromSuperview()
        }
    }
}

// MARK: 按钮点击
extension HComposeView {
    @objc private func composeButtonClick(btn: HComposeButton) {
        
        // 设置按钮放大和缩小动画
        UIView.animate(withDuration: 0.25, animations: {
            // 遍历6个按钮的数组
            for button in self.composeButtonsArray {
                // 透明度设置为0.2
                button.alpha = 0.2
                // 判断是否是点击的按钮
                if btn == button {
                    // 放大操作
                    button.transform = CGAffineTransform(scaleX: 2, y: 2)
                }else {
                    // 缩小操作
                    button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }
            }
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.25, animations: {
                
                // 遍历6个按钮数组
                for button in self.composeButtonsArray {
                    // 透明度设置为1
                    button.alpha = 1
                    //把所有按钮的状态恢复为原样
                    button.transform = CGAffineTransform.identity
                }

            }, completion: { (_) in
                return
                // MARK: 通过字符串转class创建控制器
                /*
                 - 命名空间 指得的就是项目的名称
                 - 在OC中没有命名空间 也就是说所有的类可以通过字符串转class
                 - 在Swift 中 系统提供的类可以通过字符串转class
                 - 但是程序员自定义的类需要使用命名空间.自定义类名 才可以完成字符串转class
                 */
                /* 操作流程
                 1. 得到一个类的字符串名称 (项目名.自定义类名)
                 let className = "WB.HComposeViewController"
                 print(NSClassFromString(className)) -> Optional(WB.HComposeViewController)
                 
                 2. 通过字符串得到对应的class
                 let c = NSClassFromString(className)! as! UIViewController.Type
                 
                 3. 通过class 实例化一个对象
                 let vc = c.init()
                 print(vc) -> <WB.HComposeViewController: 0x7ff82ad8e120>
                 */
                
                print("这里可能会引起崩溃 - 因为compose.plist 文件中除了文字, 其他的classname 都没有配置")
                
                // 通过模型中的classname 得到对应的class
                let c = NSClassFromString(btn.composeModel?.classname ?? "")! as! UIViewController.Type
                // 通过class 实例化一个控制器的对象
                let vc = c.init()
                // 导航控制器
                let composeNav = HNavigationController(rootViewController: vc)
                composeNav.modalPresentationStyle = .fullScreen
                // 模态
                self.target?.present(composeNav, animated: true, completion: {
                    // 移除当前的视图
                    self.removeFromSuperview()
                })
            })
        })
    }
}

//MARK:- 加载plist文件
extension HComposeView {
    
    func loadPlist() -> [HComposeModel]{
        // 获取路径
        let file = Bundle.main.path(forResource: "compose.plist", ofType: nil)!
        // 获取plistArray
        let plistArray = NSArray(contentsOfFile: file)!
        
        var tempArray: [HComposeModel] = [HComposeModel]()
        for dict in plistArray {
            let model = HComposeModel(dict: dict as! [String : Any])
            tempArray.append(model)
        }
        return tempArray
    }
}

// MARK: 截屏
extension HComposeView {
    private func screenShot() -> UIImage? {
        // 1. 拿到主window
        let window = UIApplication.shared.windows.first!
        // 2. 开启图像上下文
        UIGraphicsBeginImageContext(window.frame.size)
        // 3. 把window上的内容渲染到上下文中
        // iOS7.0 之后提出的, afterScreenUpdates表示是否在屏幕更新后渲染
        window.drawHierarchy(in: window.frame, afterScreenUpdates: false)
        // 4. 从上下文中获取到image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 5. 关闭上下文
        return image
    }
}

