//
//  CreateMeetingPointWithGroupViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 5/20/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
//import GoogleMaps

class CreateMeetingPointWithGroupViewController: GlobalViewController,MeetingPointViewControllerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgColorLine: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    var meetingView :MeetingPointViewController!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var imgTraingle: UIImageView!
    var imgsDict: NSMutableDictionary = NSMutableDictionary()
    
    var group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.downloadImageFromServer()
        self.setSubviewsConfig()
        self.addGroupUsersImagesToScroll()
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
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.purpleHome()
        self.navigationController?.navigationBar.setBackgroundImage(ImageProcessor.imageWithColor(UIColor.purpleHome()), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.rightBarButtonItem = nil
        self.title = "\(self.group.nvGroupName)"
    }
    
    func setSubviewsSettings(){
        self.meetingView = self.storyboard?.instantiateViewControllerWithIdentifier("MeetingPointViewControllerId") as! MeetingPointViewController
        self.meetingView.delegate = self
        
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.hidden = true
        self.imgColorLine.image = UIImage(named: "colorline_groups")
        self.imgColorLine.hidden = true
        self.mapView.backgroundColor = UIColor.clearColor()
        
        self.meetingView.groupsList = [self.group]
        self.meetingView.meetingPoint = MeetingPoint()
        
        self.mapView.delegate = self
        var controllers = self.navigationController?.viewControllers as [AnyObject]!
        for view in controllers{
            if view.isKindOfClass(MainPage){
                let viewH = CGFloat(275.5)
                self.meetingView.view.frame = CGRectMake(0,self.view.frame.size.height - viewH,self.meetingView.view.frame.size.width,viewH)
                self.view.addSubview(self.meetingView.view)
                
                self.mapView.camera = nil
                self.mapView.camera = GMSCameraPosition(target: (view as! MainPage).myLocationMarker.position, zoom: 15, bearing: 0, viewingAngle: 0)
                
                var marker = GMSMarker()
                marker.position = (view as! MainPage).myLocationMarker.position
                marker.map = self.mapView
                marker.icon = UIImage(named: "create_meeting_long_press")
                marker.draggable = true
                
                self.meetingView.marker = marker
            }
            
            if view.isKindOfClass(CreateMeetingPointWithGroupViewController)
            {let viewH = CGFloat(290)
                self.meetingView.view.frame = CGRectMake(0,self.view.frame.size.height - viewH,self.meetingView.view.frame.size.width,viewH)
                self.view.addSubview(self.meetingView.view)
                self.view.bringSubviewToFront(self.mapView)
                
                
                
            }
            
        }
        
        self.viewLine.backgroundColor = UIColor.clearColor()
        self.viewLine.hidden = true
        self.lblLine.hidden = true
        self.imgTraingle.hidden = true
        self.lblLine.backgroundColor = UIColor.purpleHome()
        self.imgTraingle.image = UIImage(named: "traingle-purple")
    }
    
    func setSubviewsFrames(){
        let scrollH = CGFloat(67.5)
        let imgColorH = CGFloat(1)
        let imgTraingleW = CGFloat(self.imgTraingle.image!.size.width/2)
        let imgTraingleH = CGFloat(self.imgTraingle.image!.size.height/2)
        let lblLineH = CGFloat(1.5)
        let viewLineH = CGFloat(imgTraingleH)
        self.mapView.frame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height - self.meetingView.view.frame.size.height )
    }
    
    func downloadImageFromServer(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for currUser in self.group.UsersList{
                self.imgsDict.setObject(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forKey:"\((currUser as! User).iUserId)")
            }
        })
    }
    
    func addGroupUsersImagesToScroll(){
        let spaceFromTheViewFrame = CGFloat(15.0)
        let spaceBetweenBtns = CGFloat(7.0)
        var nextX = spaceFromTheViewFrame
        let btnsSize = CGFloat(37.5)
        let btnsY = (self.scrollView.frame.size.height - btnsSize)/2
        for currUser in self.group.UsersList{
            var btnUser = UIButton(frame: CGRectMake(nextX, btnsY, btnsSize, btnsSize))
            btnUser.setBackgroundImage(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forState: UIControlState.Normal)
            btnUser.setBackgroundImage(ImageHandler.getImageBase64FromUrl((currUser as! User).nvImage), forState: UIControlState.Highlighted)
            btnUser.layer.cornerRadius = 14
            btnUser.layer.borderWidth = 1.5
            btnUser.layer.borderColor = UIColor.greenHome().CGColor
            btnUser.contentMode = UIViewContentMode.ScaleAspectFill
            btnUser.clipsToBounds = true
            
            nextX = nextX + btnsSize + spaceBetweenBtns
            
            //self.scrollView.contentSize = CGSizeMake(btnUser.frame.origin.x + btnsSize + spaceFromTheViewFrame, self.scrollView.frame.size.height)
            //self.scrollView.addSubview(btnUser)
        }
    }
    
    func mapView(mapView: GMSMapView!, didBeginDraggingMarker marker: GMSMarker!) {
        println("didBeginDraggingMarker")
        marker.icon = UIImage(named: "create_meeting_release")
    }
    
    func mapView(mapView: GMSMapView!, didEndDraggingMarker marker: GMSMarker!) {
        println("didEndDraggingMarker")
        marker.icon = UIImage(named: "create_meeting_long_press")
    }
    
    func didEndCreateMeetingPoint(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
