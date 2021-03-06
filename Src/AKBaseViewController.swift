//
//  HGBaseViewController.swift
//  HIG
//
//  Created by arkin on 2016/10/11.
//  Copyright © 2016年 arkin. All rights reserved.
//

import UIKit

let kNavigationBarHeight: CGFloat = 64
let kTabBarHeight: CGFloat = 49
let KScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let KScreenHeight: CGFloat = UIScreen.main.bounds.size.height

enum AKStatusBarStyle {
    case light
    case dark
}

public class AKNavigationItem {
    var title: String = ""
    var image: UIImage?
    var action: (()->Void)?
    
    init(_ title: String, action:@escaping ()->Void) {
        self.title = title
        self.action = action
    }
    
    init(_ image: UIImage?, action:@escaping ()->Void) {
        self.image = image
        self.action = action
    }
    
    @objc func itemAction() {
        if let _ = action {
            action!()
        }
    }
}

public class AKBaseViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: statusbar style
    var statusBarStyle: AKStatusBarStyle = .light { // MARK:here to change default statusbar style
        didSet {
            updateStatusBarInCurrentViewControllerOrNavigationController()
        }
    }
    
    // MARK: navbar hidden
    var hideNavBar: Bool = false {
        didSet {
            navBar.isHidden = hideNavBar
        }
    }
    
    var hideNavSepLine: Bool = false {
        didSet {
            sepLine.isHidden = hideNavSepLine
        }
    }
    
    lazy var navBar: UIImageView = {
        let bar = UIImageView(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:kNavigationBarHeight))
        bar.autoresizingMask = .flexibleWidth
        bar.backgroundColor = UIColor.white
        bar.addSubview(self.sepLine)
        self.view.addSubview(bar)
        return bar
    }()
    
    private lazy var sepLine: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: kNavigationBarHeight - CGFloat(1 / UIScreen.main.scale), width: self.view.frame.size.width, height: CGFloat(1 / UIScreen.main.scale)))
        line.backgroundColor = UIColor.hex(from: 0xffb2b4b8)
        line.autoresizingMask = .flexibleWidth
        return line
    }()
    
    var navBarBackgroundColor: UIColor? {
        didSet {
            navBar.image = nil
            navBar.backgroundColor = navBarBackgroundColor
        }
    }
    
    var navBarBackgroundImage: UIImage? {
        didSet {
            if let _ = navBarBackgroundImage {
                navBar.image = navBarBackgroundImage
            }
        }
    }
    
    // MARK: nav title
    var navTitleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 44))
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .center
        title.isHidden = true
        return title
    }()
    
    var navTitle: String? {
        didSet {
            navTitleLabel.numberOfLines = 1
            navTitleLabel.text = navTitle
            navTitleLabel.sizeToFit()
            navTitleLabel.textColor = navTitleColor
            navigationItem.titleView = self.navTitleLabel
        }
    }
    
    var navAttributeTitle: NSAttributedString? {
        didSet {
            navTitleLabel.numberOfLines = 0
            navTitleLabel.adjustsFontSizeToFitWidth = true
            navTitleLabel.minimumScaleFactor = 0.5
            navTitleLabel.attributedText = navAttributeTitle
            navigationItem.titleView = self.navTitleLabel
        }
    }
    
    var navTitleColor: UIColor = UIColor.white { // MARK:here to change default nav title color
        didSet {
            navTitleLabel.textColor = navTitleColor
        }
    }
    
    // MARK: left bar button item
    var leftTitle: String? {
        didSet {
            if leftTitle != nil && !leftTitle!.isEmpty {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftTitle, style: .plain, target: self, action: #selector(navLeft))
                navigationItem.leftBarButtonItem?.tintColor = leftButtonColor
            } else {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var leftImage: UIImage? {
        didSet {
            if let _ = leftImage {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(navLeft))
                navigationItem.leftBarButtonItem?.tintColor = leftButtonColor
            } else {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var leftItems: [AKNavigationItem]? {
        didSet {
            if leftItems != nil && !leftItems!.isEmpty {
                var barButtonItems = [UIBarButtonItem]()
                for item in leftItems! {
                    if let _ = item.image {
                        let barButtonItem = UIBarButtonItem(image: item.image, style: .plain, target: item, action: #selector(item.itemAction))
                        barButtonItem.tintColor = leftButtonColor
                        barButtonItems.append(barButtonItem)
                    } else {
                        let barButtonItem = UIBarButtonItem(title: item.title, style: .plain, target: item, action: #selector(item.itemAction))
                        barButtonItem.tintColor = leftButtonColor
                        barButtonItems.append(barButtonItem)
                    }
                }
                navigationItem.leftBarButtonItems = barButtonItems
            } else {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var leftButtonColor: UIColor = UIColor.white { // MARK:here to change default left bar color
        didSet {
            if let _ = navigationItem.leftBarButtonItems {
                for item in navigationItem.leftBarButtonItems! {
                    item.tintColor = leftButtonColor
                }
            }
        }
    }
    
    // MARK: right bar button item
    var rightTitle: String? {
        didSet {
            if rightTitle != nil && !rightTitle!.isEmpty {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: #selector(navRight))
                navigationItem.rightBarButtonItem?.tintColor = rightButtonColor
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            if let _ = rightImage {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(navRight))
                navigationItem.rightBarButtonItem?.tintColor = rightButtonColor
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var rightItems: [AKNavigationItem]? {
        didSet {
            if rightItems != nil && !rightItems!.isEmpty {
                var barButtonItems = [UIBarButtonItem]()
                for item in rightItems! {
                    if let _ = item.image {
                        let barButtonItem = UIBarButtonItem(image: item.image, style: .plain, target: item, action: #selector(item.itemAction))
                        barButtonItem.tintColor = rightButtonColor
                        barButtonItems.append(barButtonItem)
                    } else {
                        let barButtonItem = UIBarButtonItem(title: item.title, style: .plain, target: item, action: #selector(item.itemAction))
                        barButtonItem.tintColor = rightButtonColor
                        barButtonItems.append(barButtonItem)
                    }
                }
                navigationItem.rightBarButtonItems = barButtonItems
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
            }
        }
    }
    
    var rightButtonColor: UIColor = UIColor.white { // MARK:here to change default right bar color
        didSet {
            if let _ = navigationItem.rightBarButtonItems {
                for item in navigationItem.rightBarButtonItems! {
                    item.tintColor = rightButtonColor
                }
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initParameters()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initParameters()
    }
    
    func initParameters() {
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        NotificationCenter.default.addObserver(self, selector: #selector(ApplicationWillEnterForeground), name:.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ApplicationDidEnterBackground), name:.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ApplicationDidBecomeActive), name:.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ApplicationWillResignActive), name:.UIApplicationWillResignActive, object: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        if navigationController != nil &&
            navigationController!.viewControllers.count > 1 &&
            navigationController!.viewControllers.last == self &&
            leftTitle == nil &&
            leftImage == nil{
            leftImage = UIImage(named: "ak_back")
        }
        
        if leftTitle == nil && leftImage == nil {
            leftTitle = "" // hold position
        }
        
        if rightTitle == nil && rightImage == nil {
            rightTitle = "" // hold position
        }
        
        if let image = navBarBackgroundImage {
            navBarBackgroundImage = image
        }
        
        if let color = navBarBackgroundColor {
            navBarBackgroundColor = color
        } else {
            navBarBackgroundColor = UIColor.hex(from: 0xFF37363C) // MARK:here to change default navbar background color
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navTitleLabel.isHidden = false // fix bug of layout
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStatusBarInCurrentViewControllerOrNavigationController()
        view.bringSubview(toFront: navBar)
    }
    
    func updateStatusBarInCurrentViewControllerOrNavigationController() {
        if let nav = navigationController as? AKNavigationController {
            nav.statusBarStyle = statusBarStyle
        } else {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        switch statusBarStyle {
        case .dark: return .default
        case .light: return .lightContent
        }
    }
}

// MARK: need override
extension AKBaseViewController {
    
    func navLeft() {
        if navigationController != nil &&
            navigationController!.viewControllers.count > 1 &&
            navigationController!.viewControllers.last == self {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func navRight() {
        
    }
    
    func ApplicationWillEnterForeground() {
        
    }
    
    func ApplicationDidEnterBackground() {
        
    }
    
    func ApplicationDidBecomeActive() {
        
    }
    
    func ApplicationWillResignActive() {
        
    }
}

