//
//  HOAuthViewController.swift
//  WB
//
//  Created by 李贺 on 2020/4/1.
//  Copyright © 2020 Heli. All rights reserved.
//
/** 微博授权控制器 -> 就是登录控制器
 - OAuth授权
    - open auth 开放的授权
 - 使用微博OAuth授权,  做的是自己的项目, 显示的数据是新浪微博提供的数据
 - 如何才可以获取到新浪微博的数据
    - 注册一个新浪微博账号
    - 登录http://www.open.weibo.com (新浪微博开发者中心)
    - 成为开发者
        - 个人版
        - 企业版 -> 公司
    - 在自己的app中使用新浪微博提供的数据
    - 添加测试账号(在当前app 没有上架之前只有测试账号才可以拿到新浪微博的数据)  上架以后 只要使用当前app的使用者均可以访问新浪微博的数据
    - 登录开发者中心,  完善个人信息, 注册一个应用(微链接 -> 移动应用 -> 立即接入 ->验证成功后,重新打开, 新建应用)
    - 选择应用:
        - 应用信息 -> 基本信息 ->就会返回一些信息
             - APPKEY
             - APPSECRECT
        - 为我们获取code (授权码) token(访问令牌, 有实效性能)
        - 高级信息 -> 手动去设置回调链接
        - 测试信息 -> 输入微博用户 ->添加测试用户(之后的登录注册, 获取数据都是使用该测试账号)
    - 在我们的app中加载webView (微博授权登录界面)
    - 确认授权
    - 获取code
    - 通过code 获取 token
    - 以后请求新浪微博数据 均是通过token 获取到当前账号的微博数据
 */
import UIKit
import WebKit  // Swift 5.0之后 使用WKWebView 需要引入头文件了, 且UIWebView被废弃了

let APPKEY = "3005221540"
let APPSECRET = "f2fd98aeeea217fe40af8266a8af5334"
let REDIRECT_URI = "https://www.baidu.com"  // 重定向的地址 -> 设置的回调页, 需要和微博开放平台的高级信息中设置的相同
let WBNAME = "18513041937"      // 账号
let WBPASSWD = "ABC123456"      // 密码

class HOAuthViewController: UIViewController {

    override func loadView() {
        view = webView
        // 打开微博开放平台的文档 -> Oauth2授权 -> 选取Oauth2/authorize, 这就是授权界面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(APPKEY)&redirect_uri=\(REDIRECT_URI)"
        let url = URL(string: urlString)
        guard let u = url else { return }
        let request = URLRequest(url: u)
        // 加载webVIew
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupNav() {

        title = "微博登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(cancelButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autofillButtonClick))
    }
    
    // MARK: 懒加载 微博的oauth授权(登录)界面 -> webView
    lazy var webView: WKWebView = { [weak self] in
        let web = WKWebView()
        // 去掉WKWebView自带的 工具栏
        web.hack_removeInputAccessory()
        // 设置代理
        web.navigationDelegate = self
        return web
    }()
}


extension HOAuthViewController{
    
    @objc private func cancelButtonClick() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func autofillButtonClick() {
        // js 自动填写账号和密码
        let jsString = "document.getElementById('userId').value='\(WBNAME)';document.getElementById('passwd').value='\(WBPASSWD)';"
        // js注入
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }
}

extension HOAuthViewController: WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    // 接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 在收到响应后，决定是否跳转 -> 默认允许
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //允许跳转
        decisionHandler(.allow)
        //不允许跳转
//        decisionHandler(.cancel)
    }
    // 在发送请求之前，决定是否跳转 -> 默认允许
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        let urlString = navigationAction.request.url?.absoluteString
        print(urlString)
        /**打印结果   --> 目标: 获取code值
         Optional("https://api.weibo.com/oauth2/authorize?client_id=223130765&redirect_uri=http://www.baidu.com#")
         Optional("https://api.weibo.com/oauth2/authorize")
         Optional("https://api.weibo.com/oauth2/authorize#")
         Optional("https://api.weibo.com/oauth2/authorize")
         Optional("https://www.baidu.com/?code=4d72ded762a76b07b83d154e14fe575f")   --> 就是这条能得到code
         */
        if let u = urlString, u.hasPrefix(REDIRECT_URI) {
            // 获取整个链接的参数 (打印结果: "code=e6188852b1bd5a5b14d193e0343eb69a")
            let query = navigationAction.request.url?.query
            if let q = query {
                // 截取value 也就是获取code
                let code = String(q["code=".endIndex...])
                print("获取到的code: \(code)")
                // 拿到code 立即去获取access_token
                HOAuthViewModel.shared.getUserAccount(code: code) { (isSccuess) in
                    
                    if isSccuess {
                        print("登录成功")
                        // 移除webView
                        self.dismiss(animated: false) {
                            // 发送通知 -> 切换根控制器
                            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CHANGEVC), object: nil)
                        }
                    }else{
                        print("登录失败")
                    }
                }
                
                // 已经拿到code了. 就不需要webView继续向下进行操作了
                decisionHandler(.cancel, preferences)
                return
            }
        }
        decisionHandler(.allow, preferences)
    }
}

// MARK: 去掉WKWebView自带的 工具栏
fileprivate final class InputAccessoryHackHelper: NSObject {
    @objc var inputAccessoryView: AnyObject? { return nil }
}

extension WKWebView {
    func hack_removeInputAccessory() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let superclass = target.superclass else {
            return
        }
        
        let noInputAccessoryViewClassName = "\(superclass)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)
        
        if newClass == nil, let targetClass = object_getClass(target), let classNameCString = noInputAccessoryViewClassName.cString(using: .ascii) {
            newClass = objc_allocateClassPair(targetClass, classNameCString, 0)
            
            if let newClass = newClass {
                objc_registerClassPair(newClass)
            }
        }
        
        guard let noInputAccessoryClass = newClass, let originalMethod = class_getInstanceMethod(InputAccessoryHackHelper.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView)) else {
            return
        }
        class_addMethod(noInputAccessoryClass.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, noInputAccessoryClass)
    }
}

