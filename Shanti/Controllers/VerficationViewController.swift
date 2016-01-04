//
//  VerficationViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/3/15.
//  Copyright (c) 2015 webit. All rights reserved.
//NSLocalizedString("", comment: "")  as String

import UIKit

class VerficationViewController: GlobalViewController {
    
    var userRegister:User = User()
    var verificationCode: String = String()
    
    @IBOutlet weak var viewDailSketch: UIView!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var  btnVerifi0: UIButton!
    @IBOutlet weak var  btnVerifi1: UIButton!
    @IBOutlet weak var  btnVerifi2: UIButton!
    @IBOutlet weak var  btnVerifi3: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var numsBtnsArry: [UIButton]!
    var verifiBtns: [UIButton]!
    var presedVerificationCode: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationConfig()
        self.setSubviewsConfig()
        self.setSubviewsFrames()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationConfig(){
        self.title = NSLocalizedString("Signing up", comment: "")  as String /*"הרשמה"*/
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func setSubviewsConfig(){
        numsBtnsArry = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn0,btnDelete]
        verifiBtns = [btnVerifi0,btnVerifi1,btnVerifi2,btnVerifi3]
        
        self.lblTitle.text = NSLocalizedString("Type the verification code you got by text message SMS", comment: "")  as String/* "הזן את קוד האימות שקבלת ב-sms"*/
        self.lblTitle.textColor = UIColor.grayLight()
//        self.lblTitle.font = UIFont(name: "spacer", size: 15.0)
        self.lblTitle.backgroundColor = UIColor.clearColor()
              self.lblTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
             self.lblTitle.numberOfLines = 2
    //    self.lblTitle.sizeToFit()
        
//        self.viewDailSketch.backgroundColor = UIColor.clearColor()
//        
        self.btn0.setTitle("0", forState: UIControlState.Normal)
        self.btn0.setTitle("0", forState: UIControlState.Highlighted)
        self.btn0.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn0.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn0.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn0.backgroundColor = UIColor.clearColor()
        self.btn0.tag = 0
        
        self.btn1.setTitle("1", forState: UIControlState.Normal)
        self.btn1.setTitle("1", forState: UIControlState.Highlighted)
        self.btn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn1.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn1.backgroundColor = UIColor.clearColor()
        self.btn1.tag = 1
        
        self.btn2.setTitle("2", forState: UIControlState.Normal)
        self.btn2.setTitle("2", forState: UIControlState.Highlighted)
        self.btn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn2.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn2.backgroundColor = UIColor.clearColor()
        self.btn2.tag = 2
        
        self.btn3.setTitle("3", forState: UIControlState.Normal)
        self.btn3.setTitle("3", forState: UIControlState.Highlighted)
        self.btn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn3.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn3.backgroundColor = UIColor.clearColor()
        self.btn3.tag = 3
        
        self.btn4.setTitle("4", forState: UIControlState.Normal)
        self.btn4.setTitle("4", forState: UIControlState.Highlighted)
        self.btn4.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn4.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn4.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn4.backgroundColor = UIColor.clearColor()
        self.btn4.tag = 4
        
        self.btn5.setTitle("5", forState: UIControlState.Normal)
        self.btn5.setTitle("5", forState: UIControlState.Highlighted)
        self.btn5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn5.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn5.backgroundColor = UIColor.clearColor()
        self.btn5.tag = 5
        
        self.btn6.setTitle("6", forState: UIControlState.Normal)
        self.btn6.setTitle("6", forState: UIControlState.Highlighted)
        self.btn6.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn6.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn6.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn6.backgroundColor = UIColor.clearColor()
        self.btn6.tag = 6
        
        self.btn7.setTitle("7", forState: UIControlState.Normal)
        self.btn7.setTitle("7", forState: UIControlState.Highlighted)
        self.btn7.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn7.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn7.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn7.backgroundColor = UIColor.clearColor()
        self.btn7.tag = 7
        
        
        self.btn8.setTitle("8", forState: UIControlState.Normal)
        self.btn8.setTitle("8", forState: UIControlState.Highlighted)
        self.btn8.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn8.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        self.btn8.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn8.backgroundColor = UIColor.clearColor()
        self.btn8.tag = 8
        
        self.btn9.setTitle("9", forState: UIControlState.Normal)
        self.btn9.setTitle("9", forState: UIControlState.Highlighted)
        self.btn9.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn9.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
//        self.btn9.titleLabel!.font = UIFont(name: "spacer", size: 32)
        self.btn9.backgroundColor = UIColor.clearColor()
        self.btn9.tag = 9
        
        self.btnDelete.setTitle("", forState: UIControlState.Normal)
        self.btnDelete.setTitle("", forState: UIControlState.Highlighted)
        self.btnDelete.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        self.btnDelete.setTitleColor(UIColor.clearColor(), forState: UIControlState.Highlighted)
        self.btnDelete.backgroundColor = UIColor.clearColor()
      self.btnDelete.setBackgroundImage(UIImage(named: "delete_verify"), forState: UIControlState.Normal)
            self.btnDelete.setImage(UIImage(named: "delete_verify"), forState: UIControlState.Highlighted)
      self.btnDelete.setBackgroundImage(UIImage(named: "delete_verify"), forState: UIControlState.Highlighted)
        self.btnDelete.tag = 10
        
        for btn in self.numsBtnsArry{
            btn.addTarget(self, action: "verifiNumberPresed:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.btnVerifi0.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi0.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi0.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        self.btnVerifi1.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi1.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi1.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        self.btnVerifi2.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi2.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi2.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        self.btnVerifi3.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi3.setTitle("", forState: UIControlState.Normal)
        self.btnVerifi3.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
    
    func setSubviewsFrames(){
        let spaceFromTop = CGFloat(self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height + 16.5)
        let spaceBetweenTitleToVerifiBtns = CGFloat(18.5)
        let spaceBetweenVerifiBtnsToDailSketch = CGFloat(41.5)
        let verifiBtnsS = CGFloat(11.5)
        let verifiBtnsRadius = verifiBtnsS/2
        let spaceBetweenVerifiBtns = CGFloat(22.5)
        let firstVerifiBtnX = CGFloat((UIScreen.mainScreen().bounds.size.width - (verifiBtnsS * 4 + spaceBetweenVerifiBtns * 3))/2)
        let dailSketchW = CGFloat(207)
        let dailSketchH = CGFloat(269)
        let numBtnsS = CGFloat(70)
        let numBtnsRadius = numBtnsS/2
        
//        self.lblTitle.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - self.lblTitle.frame.size.width)/2, spaceFromTop, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)
        self.btnVerifi0.frame = CGRectMake(firstVerifiBtnX, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + spaceBetweenTitleToVerifiBtns, verifiBtnsS, verifiBtnsS)
//        self.btnVerifi0.layer.cornerRadius = verifiBtnsRadius
        self.btnVerifi1.frame = CGRectMake(self.btnVerifi0.frame.origin.x + self.btnVerifi0.frame.size.width + spaceBetweenVerifiBtns, self.btnVerifi0.frame.origin.y, verifiBtnsS, verifiBtnsS)
        self.btnVerifi1.layer.cornerRadius = verifiBtnsRadius
        self.btnVerifi2.frame = CGRectMake(self.btnVerifi1.frame.origin.x + self.btnVerifi1.frame.size.width + spaceBetweenVerifiBtns, self.btnVerifi0.frame.origin.y, verifiBtnsS, verifiBtnsS)
        self.btnVerifi2.layer.cornerRadius = verifiBtnsRadius
        self.btnVerifi3.frame = CGRectMake(self.btnVerifi2.frame.origin.x + self.btnVerifi2.frame.size.width + spaceBetweenVerifiBtns, self.btnVerifi0.frame.origin.y, verifiBtnsS, verifiBtnsS)
        self.btnVerifi3.layer.cornerRadius = verifiBtnsRadius
//
        self.paintDailSketch()
        
    }
    
    func paintDailSketch(){
        let spaceBetweenVerifiBtnsToDailSketch = CGFloat(41.5)
        let dailSketchW = CGFloat(259)
        let dailSketchH = CGFloat(336.5)
        let dailSketchHX = CGFloat(dailSketchW/3)
        let dailSketchWY = CGFloat(dailSketchH/4)
        let slotW = CGFloat(86)
        let slotH = CGFloat(84)
        let lblsStroke = CGFloat(1)
        let numBtnsS = CGFloat(70)
        let numBtnsRadius = numBtnsS/2
        
        var lblH1 = UILabel()
        var lblH2 = UILabel()
        
        var lblW1 = UILabel()
        var lblW2 = UILabel()
        var lblW3 = UILabel()
        
        lblH1.backgroundColor = UIColor.purpleShines()
        lblH2.backgroundColor = UIColor.purpleShines()
        
        lblW1.backgroundColor = UIColor.purpleShines()
        lblW2.backgroundColor = UIColor.purpleShines()
        lblW3.backgroundColor = UIColor.purpleShines()
        
//        self.viewDailSketch.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - dailSketchW)/2, self.btnVerifi0.frame.origin.y + self.btnVerifi0.frame.size.height + spaceBetweenVerifiBtnsToDailSketch, dailSketchW, dailSketchH)
        lblH1.frame = CGRectMake(dailSketchHX, 0, lblsStroke, dailSketchH)
        lblH2.frame = CGRectMake(lblH1.frame.origin.x + lblH1.frame.size.width + slotW, 0, lblsStroke, dailSketchH)
        
        lblW1.frame = CGRectMake(0, dailSketchWY, dailSketchW, lblsStroke)
        lblW2.frame = CGRectMake(0, lblW1.frame.origin.y + lblW1.frame.size.height + slotH, dailSketchW, lblsStroke)
        lblW3.frame = CGRectMake(0, lblW2.frame.origin.y + lblW2.frame.size.height + slotH, dailSketchW, lblsStroke)
        
//        self.viewDailSketch.addSubview(lblH1)
//        self.viewDailSketch.addSubview(lblH2)
//        
//        self.viewDailSketch.addSubview(lblW1)
//        self.viewDailSketch.addSubview(lblW2)
//        self.viewDailSketch.addSubview(lblW3)
//        
        var x = CGFloat(0)
        var y =  CGFloat(0)
        var index: Int = Int(0)
        
        for j in 0...3{
            for i in 0...2{
                if index > numsBtnsArry.count - 1{
                    break
                }
                
                var btn: UIButton = numsBtnsArry[index] as UIButton
                if btn == self.btn0 {
                    break
                }
                
//                btn.frame = CGRectMake((x + (slotW - numBtnsS)/2), y + (slotH - numBtnsS)/2, numBtnsS, numBtnsS)
//                btn.layer.cornerRadius = numBtnsRadius
                
                x += slotW
                index++
            }
            
            y += slotH
            x = 0
            
            if index > numsBtnsArry.count{
                break
            }
        }
        
        x = slotW
        y -= slotH
        
//        self.btn0.frame = CGRectMake((x + (slotW - numBtnsS)/2), y + (slotH - numBtnsS)/2, numBtnsS, numBtnsS)
        
        x += slotW
//        
//        let btnDeleteW = self.btnDelete.backgroundImageForState(UIControlState.Normal)!.size.width/2
//        let btnDeleteH = self.btnDelete.backgroundImageForState(UIControlState.Normal)!.size.height/2
        
//        self.btnDelete.frame = CGRectMake((x + (slotW - btnDeleteW)/2), y + (slotH - btnDeleteH)/2, btnDeleteW, btnDeleteH)
    }
    
    func verifiNumberPresed(sender: AnyObject){
        if let presedBtn = sender as? UIButton{
            if presedBtn == self.btnDelete{
                self.deleteLastVerifiNumber()
            }else{
                presedBtn.layer.cornerRadius = presedBtn.frame.size.width/2
                presedBtn.backgroundColor = UIColor.purpleShines()
                self.addVerifiNumber("\(presedBtn.tag)")
            }
        }
    }
    
   
    
    func deleteLastVerifiNumber(){
        if count(self.presedVerificationCode) > 0{
            //println("before:\(self.presedVerificationCode)")
            verifiBtns[count(self.presedVerificationCode)-1].backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            let lastChar = presedVerificationCode[presedVerificationCode.endIndex.predecessor()]
            for btn in self.numsBtnsArry{
                if "\(btn.tag)" == String(lastChar){
                    btn.layer.cornerRadius = 0
                    btn.backgroundColor = UIColor.clearColor()
                }
            }
            self.presedVerificationCode = self.presedVerificationCode.substringWithRange(Range<String.Index>(start: self.presedVerificationCode.startIndex, end: advance(self.presedVerificationCode.endIndex, -1)))
           // println("after:\(self.presedVerificationCode)")
        count(self.presedVerificationCode)
            println("test:\(self.presedVerificationCode)")
        }
    }
    
    func addVerifiNumber(number: String){
        println("before:\(self.presedVerificationCode)")
        self.presedVerificationCode = "\(self.presedVerificationCode)\(number)"
        println("after:\(self.presedVerificationCode)")
        
        for i in 0...count(self.presedVerificationCode)-1{
            verifiBtns[i].backgroundColor = UIColor.whiteColor()
        }
        
        if count(self.presedVerificationCode) == 4{
            self.verifiCode()
        }
    }
    
    func verifiCode(){
        if self.presedVerificationCode == self.verificationCode{
            var profileRegister: ProfileRegisterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileRegisterViewControllerId") as! ProfileRegisterViewController
            profileRegister.userRegister = self.userRegister
            
            self.navigationController!.pushViewController(profileRegister, animated: true)
        }else{
            for btn in self.numsBtnsArry{
                btn.layer.cornerRadius = 0
                btn.backgroundColor = UIColor.clearColor()
            }
            var alert = UIAlertController(title: NSLocalizedString("Error", comment: "")  as String /*"שגיאה"*/, message: NSLocalizedString("The code typed does not match the sent code", comment: "")  as String , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "")  as String/*"אישור"*/, style: UIAlertActionStyle.Cancel, handler: {
                action -> Void in
                self.presedVerificationCode = ""
                for i in 0...count(self.verifiBtns)-1{
                    self.verifiBtns[i].backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
