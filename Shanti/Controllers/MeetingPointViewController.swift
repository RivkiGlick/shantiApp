//
//  MeetingPointViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 4/21/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
//import GoogleMaps

protocol MeetingPointViewControllerDelegate{
    func didEndCreateMeetingPoint()
}
class MeetingPointViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var btnPrevGroup: UIButton!
    @IBOutlet weak var btnNextGroup: UIButton!
    @IBOutlet weak var txtMeettingTime: UITextField!
    @IBOutlet weak var txtSetting: UITextField!
    @IBOutlet weak var txtComment: UITextField!
    
    @IBOutlet weak var btnCreateMeetingPoint: UIButton!
    
    @IBOutlet weak var viewLineTraingle: UIView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var imgTraingle: UIImageView!
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var groupsList: [Group] = []
    var meetingPoint: MeetingPoint!
    var marker: GMSMarker!
    
    var delegate: MeetingPointViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviewsConfig()
        //textAlignment
        var space: CGFloat = 10
        var textAlignment: NSTextAlignment = .Left
        let languageId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        if languageId == "he"{
            textAlignment = .Right
            space = -space
        }
        
        txtComment.textAlignment = textAlignment
        txtMeettingTime.textAlignment = textAlignment
        txtSetting.textAlignment = textAlignment
        
        
        //make cornerRadius and location placeHolder to the UITextField
        for view in self.viewDetails.subviews{
            if view.isKindOfClass(UITextField){
                view.layer.cornerRadius = 3
                view.layer.sublayerTransform = CATransform3DMakeTranslation(space,0,0)
            }
        }
        
        //        self.viewLineTraingle.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubviewsConfig(){
        self.setNavigationSettings()
        self.setSubviewsSettings()
        self.setSubviewsFrames()
    }
    
    func setNavigationSettings(){
        self.navigationController?.navigationBarHidden = true
    }
    
    func setSubviewsSettings(){
        
        self.lblLine.backgroundColor = UIColor.purpleColor()
        self.lblTitle.text = NSLocalizedString("Setting a meeting point", comment: "") as String/*"קביעת נקודת מפגש"*/
        self.lblTitle.textColor = UIColor.purpleHome()
        
        self.lblGroupName.text = groupsList.count > 0 ? groupsList[0].nvGroupName : ""
        self.lblGroupName.tag = 0
        self.lblGroupName.textColor = UIColor.grayMedium()
        self.lblGroupName.backgroundColor = UIColor.purpleGray()
        self.btnPrevGroup.addTarget(self, action: "getPrevGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.txtMeettingTime.placeholder = NSLocalizedString("Meeting time", comment: "") as String/*"שעת מפגש"*/
        self.txtMeettingTime.delegate = self
        self.txtMeettingTime.textColor = UIColor.grayMedium()
        self.txtMeettingTime.layer.borderColor = UIColor.offwhiteDark().CGColor
        self.txtMeettingTime.layer.borderWidth = 1
        
        self.datePicker.datePickerMode = UIDatePickerMode.Time
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.txtMeettingTime.inputView = self.datePicker
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.barTintColor = UIColor.blackColor()
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        
        var btnOk = UIBarButtonItem(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: .Plain, target: self.view.superview, action: "getTimeFromDatePicker:")
        var btnCancel = UIBarButtonItem(title:NSLocalizedString("Cancellation", comment: "") as String /*"ביטול"*/, style: UIBarButtonItemStyle.Done, target: self.view.superview, action: "cancelDatePickerSelection:")
        var btnFixSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.items = [btnOk,btnFixSpace,btnCancel]
        self.txtMeettingTime.inputAccessoryView = toolBar
        
        self.txtSetting.placeholder = NSLocalizedString("Definition", comment: "") as String/*"הגדרה"*/
        self.txtSetting.delegate = self
        self.txtSetting.textColor = UIColor.grayMedium()
        self.txtSetting.layer.borderColor = UIColor.offwhiteDark().CGColor
        self.txtSetting.layer.borderWidth = 1
        
        self.txtComment.placeholder = NSLocalizedString("Notes", comment: "") as String/*"הערות"*/
        self.txtComment.delegate = self
        self.txtComment.textColor = UIColor.grayMedium()
        self.txtComment.layer.borderColor = UIColor.offwhiteDark().CGColor
        self.txtComment.layer.borderWidth = 1
        
        //btnCreateMeetingPoint
        self.btnCreateMeetingPoint.backgroundColor = UIColor.purpleShines()
        self.btnCreateMeetingPoint.setTitle(NSLocalizedString("Set a meeting point", comment: "") as String/*"צור נקודת מפגש"*/, forState: UIControlState.Normal)
        self.btnCreateMeetingPoint.setTitle(NSLocalizedString("Set a meeting point", comment: "") as String/*"צור נקודת מפגש"*/, forState: UIControlState.Highlighted)
        self.btnCreateMeetingPoint.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnCreateMeetingPoint.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnCreateMeetingPoint.addTarget(self, action: "createMeetingPoint:", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnCreateMeetingPoint.layer.borderWidth = 1.0
        self.btnCreateMeetingPoint.layer.borderColor = UIColor.purpleMedium().CGColor
        
    }
    
    func setSubviewsFrames(){
        let txtsW = CGFloat(291)
        let txtsH = CGFloat(46.0)
        let lblLineH = CGFloat(1)
        let btnCreateMeetingPointH = CGFloat(50)
        
        var btnPrevGroupImage = btnPrevGroup.backgroundImageForState(UIControlState.Normal)
        var btnNextGroupImage = btnNextGroup.backgroundImageForState(UIControlState.Normal)
        
        let txtsX = CGFloat((self.view.frame.size.width - txtsW)/2)
        let viewH = self.btnCreateMeetingPoint.frame.origin.y + self.btnCreateMeetingPoint.frame.size.height
    }
    
    func getTimeFromDatePicker(sender: AnyObject){
        println("getTimeFromDatePicker")
        self.txtMeettingTime.resignFirstResponder()
        var date = self.datePicker.date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.txtMeettingTime.text = "\(dateFormatter.stringFromDate(date))"
    }
    
    func cancelDatePickerSelection(sender: AnyObject){
        println("cancelDatePickerSelection")
        self.txtMeettingTime.resignFirstResponder()
        self.txtMeettingTime.text = ""
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 220, self.view.frame.size.width, self.view.frame.size.height)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        textField.resignFirstResponder()
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 220, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func getNextGroup(sender: AnyObject){
        var currIndex = self.lblGroupName.tag
        if currIndex + 1 > self.groupsList.count - 1{
            currIndex = 0
        }else{
            currIndex++
        }
        
        self.lblGroupName.tag = currIndex
        self.lblGroupName.text = self.groupsList[currIndex].nvGroupName
        self.lblGroupName.sizeToFit()
        
        self.fixFrames()
    }
    
    func getPrevGroup(sender: AnyObject){
        var currIndex = self.lblGroupName.tag
        
        if currIndex - 1 <= -1{
            currIndex = 0
        }else{
            currIndex--
        }
        
        self.lblGroupName.tag = currIndex
        self.lblGroupName.text = self.groupsList[currIndex].nvGroupName
        self.lblGroupName.sizeToFit()
        
        self.fixFrames()
    }
    
    func fixFrames(){
        let spaceBetweenBtnsToLbl = CGFloat(5)
        
        self.lblGroupName.frame = CGRectMake((self.view.frame.size.width - self.lblGroupName.frame.size.width)/2, self.lblGroupName.frame.origin.y, self.lblGroupName.frame.size.width, self.lblGroupName.frame.size.height)
        
        var btnPrevGroupImage = btnPrevGroup.backgroundImageForState(UIControlState.Normal)!
        
        if (self.lblGroupName.frame.origin.x - btnPrevGroupImage.size.width/2 - spaceBetweenBtnsToLbl) < 0{
            self.btnPrevGroup.frame = CGRectMake(0, self.btnPrevGroup.frame.origin.y, self.btnPrevGroup.frame.size.width, self.btnPrevGroup.frame.size.height)
            self.lblGroupName.frame = CGRectMake(self.btnPrevGroup.frame.origin.x + self.btnPrevGroup.frame.size.width + spaceBetweenBtnsToLbl, self.lblGroupName.frame.origin.y, self.lblGroupName.frame.size.width, self.lblGroupName.frame.size.height)
        }else{
            self.btnPrevGroup.frame = CGRectMake(lblGroupName.frame.origin.x - btnPrevGroupImage.size.width/2 - 5, lblGroupName.frame.origin.y, btnPrevGroupImage.size.width/2, btnPrevGroupImage.size.height/2)
        }
        
        var btnNextGroupImage = btnNextGroup.backgroundImageForState(UIControlState.Normal)!
    }
    
    func createMeetingPoint(sender: AnyObject){
        self.txtMeettingTime.resignFirstResponder()
        self.txtSetting.resignFirstResponder()
        self.txtComment .resignFirstResponder()
        
        self.marker.draggable = false
        
        var currGroup = self.groupsList.filter{ $0.nvGroupName == self.lblGroupName.text }.first
        if currGroup != nil{
            self.meetingPoint.iGroupId = currGroup!.iGroupId
            self.meetingPoint.oLocation.dLatitude = Double(self.marker.position.latitude)
            self.meetingPoint.oLocation.dLongitude = Double(self.marker.position.longitude)
            self.meetingPoint.dtMeetingTime = self.txtMeettingTime.text
            self.meetingPoint.nvTitle = self.txtSetting.text
            self.meetingPoint.nvComment = self.txtComment.text
            
            var generic = Generic()
            generic.showNativeActivityIndicator(self)
            
            Connection.connectionToService("CreateNewMeetingPoint", params: ["oMeetingPoint":MeetingPoint.getMeetingPointDict(self.meetingPoint)], completion: {
                data -> Void in
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("CreateNewMeetingPoint:\(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                if json !=  nil{
                    let meetingPoint = MeetingPoint.parsMeetingPointDict(json!)
                    
                    if meetingPoint.iMeetingPointId != -1 && meetingPoint.iMeetingPointId != 0{
                        var alert = UIAlertController(title: "", message:NSLocalizedString("The meeting point has been added successfully", comment: "The meeting point has been added successfully" ) as String /*"נקודת המפגש התווספה בהצלחה"*/, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                            self.navigationController?.popViewControllerAnimated(true)
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        var alert = UIAlertController(title: NSLocalizedString("Error", comment: "") as String/*"שגיאה"*/, message:NSLocalizedString("An error occurred during creation of a meeting point לקבוצת for group", comment: "") as String/* "ארעה שגיאה, נקודת המפגש לא התווספה "*/, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                            println("error!")
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }else{
                    var alert = UIAlertController(title:NSLocalizedString("Error", comment: "") as String/* "שגיאה"*/, message: NSLocalizedString("An error occurred during creation of a meeting point לקבוצת for group", comment: "") as String/*"ארעה שגיאה, נקודת המפגש לא התווספה "*/, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirmation", comment: "") as String/*"אישור"*/, style: UIAlertActionStyle.Default, handler:{ action in action.style
                        println("error!")
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                generic.hideNativeActivityIndicator(self)
                self.marker.map = nil
                self.txtSetting.text = ""
                self.txtMeettingTime.text = ""
                self.txtComment.text = ""
                self.delegate?.didEndCreateMeetingPoint()
                self.view.removeFromSuperview()
            })
        }
        
    }
    
    
}
