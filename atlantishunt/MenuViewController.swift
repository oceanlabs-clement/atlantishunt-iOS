//
//  MenuViewController.swift
//  atlantishunt
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit
import WebKit

class MenuViewController: UIViewController {
    
    // UI Elements
    let startButton = UIButton(type: .system)
    let scoreHistoryButton = UIButton(type: .system)
    let logoImageView = UIImageView()
    
//    private var didLayout: Bool = false
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tabBarBgView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var floatingBgView: UIView!
    @IBOutlet weak var triggerTabBarButton: UIButton!
    
    
    var urlString = ""
    var homepageUrlString = ""
    var externalUrlArray: [String] = []
    
    let safeAreaHeight: CGFloat = 20
    let tabBarHeight: CGFloat = 50
    let panGesture = UIPanGestureRecognizer()
    
    var isCollapse: Bool = false
    var isHideTabBar: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingBgView.isHidden = true
        floatingBgView.layer.cornerRadius = 10
        
        panGesture.addTarget(self, action: #selector(draggedView(sender:)))
        panGesture.cancelsTouchesInView = true
        
        callApiToCheckStatus()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        if !didLayout == true {
//            didLayout = true
//            
//            setupUI()
//        }
//    }
    
    func setupUI() {
        // Setup background image
        let backgroundImage = UIImage(named: "image_bg") // Add a background image to the Assets
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        // Configure logo image
        logoImageView.frame = CGRect(x: (view.frame.width - 300) / 2, y: view.frame.height / 2 - 250, width: 300, height: 300)
        logoImageView.image = UIImage(named: "image_logo_menu") // Add a logo image to the Assets
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        // Configure start button
        startButton.frame = CGRect(x: (view.frame.width - 200) / 2, y: view.frame.height / 2 + 150, width: 200, height: 50)
        startButton.setTitle("Start Game", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 20
        view.addSubview(startButton)
        
        // Configure score history button
        scoreHistoryButton.frame = CGRect(x: (view.frame.width - 200) / 2, y: startButton.frame.maxY + 20, width: 200, height: 50)
        scoreHistoryButton.setTitle("Score History", for: .normal)
        scoreHistoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        scoreHistoryButton.addTarget(self, action: #selector(viewScoreHistory), for: .touchUpInside)
        scoreHistoryButton.setTitleColor(.white, for: .normal)
        scoreHistoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        scoreHistoryButton.layer.borderWidth = 2
        scoreHistoryButton.layer.borderColor = UIColor.white.cgColor
        scoreHistoryButton.layer.cornerRadius = 20
        view.addSubview(scoreHistoryButton)
    }
    
    @objc func startGame() {
        let gameVC = ViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true, completion: nil)
    }
    
    @objc func viewScoreHistory() {
        let historyVC = ScoreHistoryViewController()
        historyVC.modalPresentationStyle = .formSheet
        present(historyVC, animated: true, completion: nil)
    }
}

extension MenuViewController {
    
    // MARK: - Call Api
    
    func callApiToCheckStatus() {
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://6703907dab8a8f892730a6d2.mockapi.io/api/v1/newtestt")!, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
//                    self.loadingView.stopAnimating()
                }
//                print(String(describing: error))
                semaphore.signal()
                return
            }
//            print("\n[ViewController] thesnake data: ")
//            print(String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [[String:Any]]
//                print("\nCheck json data: ", json)
                
                if let isOpen = json?[0]["is_on"] as? Bool {
                    if isOpen == true {
                        self.urlString = json?[0]["url"] as? String ?? ""
                        if let url = URL(string: self.urlString) {
                            
                            self.externalUrlArray = json?[0]["external_url"] as! [String]
//                            print("\nCheck externalUrlArray: ", self.externalUrlArray)
                            
                            let request = URLRequest(url: url)
                            
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
                                triggerTabBarButton.addGestureRecognizer(panGesture)
                                triggerTabBarButton.touchesCancelled([], with: nil)
                                
                                self.view.backgroundColor = .black
//                                self.gameBgView.isHidden = true
                                self.floatingBgView.isHidden = false
                                self.webView.isHidden = false
                                self.webView.load(request)
                                
                                self.webView.uiDelegate = self
                                self.webView.navigationDelegate = self
                                
                                stackView.isHidden = false
                                tabBarBgView.isHidden = false
                                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight-safeAreaHeight, width: self.view.bounds.width, height: tabBarHeight)
                            }
                        }
                        else {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
//                                configureGameView()
                                setupUI()
                                
                                self.view.backgroundColor = .white
//                                self.gameBgView.isHidden = false
                                self.floatingBgView.isHidden = true
                                self.webView.isHidden = true
//                                self.startNewGame()
                                
                                stackView.isHidden = true
                                tabBarBgView.isHidden = true
                                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
//                            configureGameView()
                            setupUI()
                            
                            self.view.backgroundColor = .white
//                            self.gameBgView.isHidden = false
                            self.floatingBgView.isHidden = true
                            self.webView.isHidden = true
//                            self.startNewGame()
                            
                            stackView.isHidden = true
                            tabBarBgView.isHidden = true
                            tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
//                        configureGameView()
                        setupUI()
                        
                        self.view.backgroundColor = .white
//                        self.gameBgView.isHidden = false
                        self.floatingBgView.isHidden = true
                        self.webView.isHidden = true
//                        self.startNewGame()
                        
                        stackView.isHidden = true
                        tabBarBgView.isHidden = true
                        tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                    }
                    
                }
                
//                let jsonData = try JSONDecoder().decode([GetDataResponse].self, from: data)
//                print("\nJson data:")
//                print(jsonData)
                
            } catch let jsonError {
//                print("[API checkStatus] Failed to decode:", jsonError)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
//                    configureGameView()
                    setupUI()
                    
                    self.view.backgroundColor = .white
//                    self.gameBgView.isHidden = false
                    self.floatingBgView.isHidden = true
                    self.webView.isHidden = true
//                    self.startNewGame()
                    
                    stackView.isHidden = true
                    tabBarBgView.isHidden = true
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 0)
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    @IBAction func button2OnTapped(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        
        if button == homeButton {
            if let url = URL(string: self.homepageUrlString) {
                let request = URLRequest(url: url)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.webView.load(request)
                }
            }
        }
        else if button == leftButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.goBack()
            }
        }
        else if button == rightButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.goForward()
            }
        }
        else if button == refreshButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.reload()
            }
        }
        else if button == triggerTabBarButton {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                isHideTabBar = !isHideTabBar
                tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight, width: self.view.bounds.width, height: isHideTabBar == true ? 0 : tabBarHeight)
                tabBarBgView.isHidden = isHideTabBar == true ? true : false
                
                if isHideTabBar == true {
                    webView.frame = CGRect(x: 0, y: tabBarHeight, width: self.view.bounds.width, height: self.view.bounds.height-tabBarHeight)
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height+safeAreaHeight, width: self.view.bounds.width, height: 0)
                }
                else {
                    webView.frame = CGRect(x: 0, y: tabBarHeight, width: self.view.bounds.width, height: self.view.bounds.height-tabBarHeight-safeAreaHeight-tabBarHeight)
                    tabBarBgView.frame = CGRect(x: 0, y: self.view.bounds.height-tabBarHeight-safeAreaHeight, width: self.view.bounds.width, height: tabBarHeight)
                }
            }
        }
        // end else if
        
    }
    
    // MARK: - Orientation Change
    
    @objc func orientationChange() {
        draggedView(sender: panGesture)
    }
    
    // MARK: - Floating View Pan Gesture
    
    @objc func draggedView(sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(floatingBgView)
        let translation = sender.translation(in: self.view)
        let xPostion = floatingBgView.center.x + translation.x
        let yPostion = floatingBgView.center.y + translation.y - floatingBgView.frame.height
        
        if UIDevice.current.orientation == .portrait {
            if (xPostion >= 25 && xPostion <= self.view.frame.size.width - 25) && (yPostion >= 30 && yPostion <= self.view.frame.size.height-150) {
                floatingBgView.center = CGPoint(x: floatingBgView.center.x + translation.x, y: floatingBgView.center.y + translation.y)
                sender.setTranslation(.zero, in: self.view)
                
            }
        }
        else {
            if (xPostion >= (25+48) && xPostion <= self.view.frame.size.width - (25+48) ) && (yPostion >= -20 && yPostion <= self.view.frame.size.height-100) {
                floatingBgView.center = CGPoint(x: floatingBgView.center.x + translation.x, y: floatingBgView.center.y + translation.y)
                sender.setTranslation(.zero, in: self.view)
                
            }
        }
        
    }
    
}

// MARK: - Web View UI Delegate

extension MenuViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (!(navigationAction.targetFrame?.isMainFrame ?? false)) {
            self.webView.load(navigationAction.request)
            
//            homepageUrlString = "\(navigationAction.request.url)"
//            print("\nCreate webview with: ")
//            print("homepageUrlString: ", homepageUrlString)
        }
        
        return nil
    }
}

// MARK: - Web View Navigation Delegate

extension MenuViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
//        print("\nDecidePolicyFor: ")
//        print("absoluteString: ", webView.url?.absoluteString)
        
        if let newExternalUrl = webView.url?.absoluteString {
            if self.externalUrlArray.contains(newExternalUrl) {
                UIApplication.shared.open(URL(string: webView.url?.absoluteString ?? "")!, options: [:], completionHandler: nil)
                return .cancel
            }
        }
        
        return .allow
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let newUrl = webView.url?.absoluteString {
            if homepageUrlString.count == 0 {
                homepageUrlString = newUrl
//                print("\nDidReceiveServerRedirect: ")
//                print("homepageUrlString: ", homepageUrlString)
            }
        }
    }
}


