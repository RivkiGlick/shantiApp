//
//  GlobalViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/17/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class GlobalViewController: UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setNavigationBarSettings()
    }
    
    func setNavigationBarSettings(){
        if self.navigationController != nil{
            self.title = ""
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor() , NSFontAttributeName: UIFont(name: "spacer", size: 30)!]
            self.setBackBtn()
            self.setMenuBtn()
        }else{
            println("navigationController == nil")
        }
    }
    
    func setBackBtn(){
        var backImg = UIImage(named: "back")
        var btnBack = UIButton()
        btnBack.setBackgroundImage(backImg, forState: UIControlState.Normal)
        btnBack.setBackgroundImage(backImg, forState: UIControlState.Highlighted)
        btnBack.setTitle("", forState: UIControlState.Normal)
        btnBack.setTitle("", forState: UIControlState.Highlighted)
        btnBack.addTarget(self, action: "popBack:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.frame = CGRectMake(0, 0, backImg!.size.width/2, backImg!.size.height/2)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: btnBack), animated: true)
    }
    
    func setMenuBtn(){
        var revealController: SWRevealViewController = self.revealViewController()
        revealController.tapGestureRecognizer()
        
        var menuImg = UIImage(named: "menu_icn")
        var btnMenu = UIButton()
        btnMenu.setBackgroundImage(menuImg, forState: UIControlState.Normal)
        btnMenu.setBackgroundImage(menuImg, forState: UIControlState.Highlighted)
        btnMenu.setTitle("", forState: UIControlState.Normal)
        btnMenu.setTitle("", forState: UIControlState.Highlighted)
        btnMenu.addTarget(revealController, action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        btnMenu.frame = CGRectMake(0, 0, menuImg!.size.width/2, menuImg!.size.height/2)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: btnMenu), animated: true)
    }
    
    func popBack(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
