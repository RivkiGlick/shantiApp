//
//  PresentFileViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 6/18/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

class PresentFileViewController: UIViewController {
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.view.backgroundColor = UIColor.whiteColor()
        var imgView = UIImageView(frame: UIScreen.mainScreen().bounds)
        println("img.size:\(img.size)")
        imgView.image = img
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
        imgView.clipsToBounds = true
        imgView.center = self.view.center
        println("imgView.frame:\(imgView.frame)")
        self.view.addSubview(imgView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
