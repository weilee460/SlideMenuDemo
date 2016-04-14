//
//  ViewController.swift
//  SlideMenuDemo
//
//  Created by ying on 16/4/13.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

// 菜单状态枚举
enum MenuState {
    case Collapsed  // 未显示(收起)
    case Expanding   // 展开中
    case Expanded   // 展开
}

class ViewController: UIViewController {
    
    //主页导航控制器
    var mainNavigationViewController: UINavigationController!
    
    //主页面控制器
    var mainViewController: MainViewController!
    
    //菜单页控制器
    var menuViewController: MenuViewController?
    
    var currentState = MenuState.Collapsed {
        didSet {
            //菜单展开的时候，给主页面边缘添加阴影
            let shouldShowShadow = currentState != .Collapsed
            showShadowForMainViewController(shouldShowShadow)
        }
    }
    
    //菜单打开后主页面在屏幕右侧露出部分的宽度
    let menuViewExpandedOffset: CGFloat = 60
    

    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        view.backgroundColor = UIColor.greenColor()
        
        //初始化主视图
        mainNavigationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainNavigation") as! UINavigationController
        view.addSubview(mainNavigationViewController.view)
        
        //指定Navigation Bar 左侧按钮事件
        mainViewController = mainNavigationViewController.viewControllers.first as! MainViewController
        mainViewController.navigationItem.leftBarButtonItem?.action = Selector("showMenu")
        
        /*
        //添加主页面
        mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainView") as! MainViewController
        mainViewController.view.backgroundColor = UIColor.yellowColor()
        view.addSubview(mainViewController.view)
        
        //建立父子关系
        addChildViewController(mainViewController)
        mainViewController.didMoveToParentViewController(self)
         */
        //添加拖动手势
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        //mainViewController.view.addGestureRecognizer(panGestureRecognizer)
        mainNavigationViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        //单击收起菜单手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handlePanGesture")
        //mainViewController.view.addGestureRecognizer(tapGestureRecognizer)
        mainNavigationViewController.view.addGestureRecognizer(tapGestureRecognizer)

    }
    
    //导航栏左侧按钮事件响应
    func showMenu()
    {
        //如果菜单是展开的，则会收起，否则就展开
        if currentState == .Expanded
        {
            animateMainView(false)
        }
        else
        {
            addMenuViewController()
            animateMainView(true)
        }
    }
    
    //拖动手势响应函数
    func handlePanGesture(recognizer: UIPanGestureRecognizer)
    {
        switch recognizer.state {
        //刚刚开始滑动
        case .Began:
            //判断拖动方向
            let dragFromLeftToRight = (recognizer.velocityInView(view).x > 0)
            //如果刚刚开始滑动的时候还处于主页面，从左向右滑动加入侧面菜单
            if (currentState == .Collapsed && dragFromLeftToRight)
            {
                currentState = .Expanding
                addMenuViewController()
            }
        //如果是正在滑动，则偏移主视图的坐标实现跟随手指位置移动
        case .Changed:
            let positionX = recognizer.view!.frame.origin.x + recognizer.translationInView(view).x
            //页面滑倒最左侧的话就不许继续向左移动
            recognizer.view?.frame.origin.x = positionX < 0 ? 0 : positionX
            recognizer.setTranslation(CGPointZero, inView: view)
        //如果滑动结束
        case .Ended:
            //根据页面滑动是否过半，判断后面是自动展开还是收缩
            let hasMovedhanHalfway = recognizer.view!.center.x > view.bounds.size.width
            animateMainView(hasMovedhanHalfway)
        default:
            break
        }
    }
    
    //单击手势响应
    func handlePanGesture()
    {
        //
        if currentState == .Expanded
        {
            animateMainView(false)
        }
    }
    
    //添加菜单项
    func addMenuViewController()
    {
        if menuViewController == nil
        {
            menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("menuView") as? MenuViewController
            menuViewController?.view.backgroundColor = UIColor.blueColor()
            
            //插入当前视图并置顶
            view.insertSubview(menuViewController!.view, atIndex: 0)
            
            //建立父子关系
            addChildViewController(menuViewController!)
            menuViewController!.didMoveToParentViewController(self)
        }
    }
    
    //主页自动展开、收起动画
    func animateMainView(shouldExpand: Bool)
    {
        //如果是用来展开
        if shouldExpand
        {
            //更新当前状态
            currentState = .Expanded
            //动画
            //animateMainViewXPosition(CGRectGetWidth(mainViewController.view.frame) - menuViewExpandedOffset)
            animateMainViewXPosition(CGRectGetWidth(mainNavigationViewController.view.frame) - menuViewExpandedOffset)
            
        }
        //如果是用于隐藏
        else
        {
            //动画
            animateMainViewXPosition(0, completion: { (finished) in
                //动画结束之后s更新状态
                self.currentState = .Collapsed
                //移除左侧视图
                self.menuViewController?.view.removeFromSuperview()
                //释放内存
                self.menuViewController = nil
            })
        }
        
    }
    
    //主页面移动动画（在x轴移动）
    func animateMainViewXPosition(targetPosition: CGFloat, completion:((Bool) -> Void)! = nil)
    {
        //
        /*
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.mainViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
            */
        //
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.mainNavigationViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    //给主页边缘添加、取消阴影
    func showShadowForMainViewController(shouldShowShadow: Bool)
    {
        if shouldShowShadow
        {
            //mainViewController.view.layer.shadowOpacity = 0.8
            mainNavigationViewController.view.layer.shadowOpacity = 0.8
        }
        else
        {
            //mainViewController.view.layer.shadowOpacity = 0.0
            mainNavigationViewController.view.layer.shadowOpacity = 0.8
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

