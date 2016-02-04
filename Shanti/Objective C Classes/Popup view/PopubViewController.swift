//
//  PopubViewController.swift
//  Shanti
//
//  Created by hodaya ohana on 2/3/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit
@objc protocol PopupViewControllerDelegate{
    func didEndSelection(arraySelections: [CodeValue], mode: String)
    //FIXME:prefix
    func didEndSelectionKey(arraySelections: [KeyValue], mode: String)
}

class PopubViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var mode = String()
    var parentView: UIViewController = UIViewController()
    var tableList: NSMutableArray = NSMutableArray()
    var delegate: PopupViewControllerDelegate?
    var selectionsArry: [CodeValue] = []
    //FIXME:prefix
    var selectionsArryKey: [KeyValue] = []
    var countriesArry: NSMutableArray = NSMutableArray()
    var languageArry: NSMutableArray = NSMutableArray()
    var religionsArry: NSMutableArray = NSMutableArray()
    var religionLevelArry: NSMutableArray = NSMutableArray()
    var ageRangeArry: NSMutableArray = NSMutableArray()
    var gendersArry: NSMutableArray = NSMutableArray()
    var radiusArry: NSMutableArray = NSMutableArray()
    var degel = 0
    
    var chooseOption: CodeValue = CodeValue()
    //FIXME:prefix
    var countryPrefixArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // arrays handle
        countriesArry = ApplicationData.sharedApplicationDataInstance.countriesArry
        languageArry = ApplicationData.sharedApplicationDataInstance.languageArry
        religionsArry = ApplicationData.sharedApplicationDataInstance.religionsArry
        religionLevelArry = ApplicationData.sharedApplicationDataInstance.religionLevelArry
        ageRangeArry = ApplicationData.sharedApplicationDataInstance.ageRangeArry
        gendersArry = ApplicationData.sharedApplicationDataInstance.gendersArry
        radiusArry =  ApplicationData.sharedApplicationDataInstance.radiusArry
        //FIXME: Prefix
        countryPrefixArray = ApplicationData.sharedApplicationDataInstance.countryPrefixArray
        chooseOption.iKeyId = -1
        chooseOption.iTableId = -1
        chooseOption.nvValue =  NSLocalizedString("Select", comment: "") as String //בחר
        
        self.tableView.registerNib(UINib(nibName: "PopUpTableViewCell", bundle: nil), forCellReuseIdentifier: "PopUpTableViewCell")
        self.tableView.reloadData()
        
        self.setSubviewsSettings()
        self.checkViewMode()
        self.setSubviewsFrames()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        for (index, element) in enumerate(self.tableList){
            if let codeVal = self.tableList.objectAtIndex(index) as? CodeValue{
                if codeVal.iKeyId == -1{
                    self.tableList.removeObjectAtIndex(index)
                    break
                }
            }
        }
    }
    
    func setSubviewsSettings(){
        self.topView.backgroundColor = UIColor.purpleHome()
        
        self.lblTitle.font = UIFont(name: "spacer", size: 19.0)
        self.lblTitle.textAlignment = NSTextAlignment.Right
        self.lblTitle.sizeToFit()
        self.lblTitle.textColor = UIColor.whiteColor()
        
        self.buttomView.backgroundColor = UIColor.purpleHome()
        self.btnApply.setTitle(NSLocalizedString("apply", comment: "")as String, forState: .Normal)
        self.btnApply.setTitle(NSLocalizedString("apply", comment: "") as String, forState: .Highlighted)
        self.btnApply.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnApply.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.btnApply.titleLabel?.font = UIFont(name: "spacer", size: 15.0)
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.searchBar.delegate = self
    }
    
    func setSubviewsFrames(){
        var viewsHight = CGFloat(44.0)
        self.topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, viewsHight)
        self.lblTitle.frame = CGRectMake(self.topView.frame.size.width - self.lblTitle.frame.size.width - 5, (self.topView.frame.size.height - self.lblTitle.frame.size.height)/2, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)
        self.searchBar.frame = CGRectMake(0, 0, self.lblTitle.frame.origin.x - 5, self.topView.frame.size.height)
        
        self.buttomView.frame = CGRectMake(0, self.view.bounds.size.height - viewsHight, self.view.bounds.size.width, viewsHight)
        self.btnApply.frame = CGRectMake((self.buttomView.frame.size.width - self.btnApply.frame.size.width)/2, (self.buttomView.frame.size.height - self.btnApply.frame.size.height)/2, self.btnApply.frame.size.width, self.btnApply.frame.size.height)
        
        self.tableView.frame = CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, self.view.bounds.size.width, self.buttomView.frame.origin.y - (self.topView.frame.origin.y + self.topView.frame.size.height))
        
    }
    
    func checkViewMode(){
        self.tableList.removeAllObjects()
        self.searchBar.hidden = true
        var text = String()
        
        switch self.mode {
        case "Language":
            tableList = self.languageArry
            text = NSLocalizedString("Spoken languages", comment: "")  as String
            break
        case "Countries":
            tableList = (self.countriesArry.mutableCopy() as! NSMutableArray)
            text =  NSLocalizedString("Country of residence", comment: "")  as String
            self.searchBar.hidden = false
            break
        case "AgeRange":
            tableList = self.ageRangeArry
            text = NSLocalizedString("Date of Birth", comment: "")  as String
            break
        case "Gender":
            tableList = self.gendersArry
            text = NSLocalizedString("Gender", comment: "")  as String
            break
        case "Religion":
            tableList = self.religionsArry
            text = NSLocalizedString("Faith", comment: "")  as String
            break
        case "ReligionLevel":
            tableList = self.religionLevelArry
            text = NSLocalizedString("ReligionLevel", comment: "")  as String
            break
        case "Radius":
            tableList = self.radiusArry
            text = NSLocalizedString("Radius", comment: "")  as String
            break
            //FIXME:prefix
        case "countryPrefixArray":
            tableList = self.countryPrefixArray
            text = NSLocalizedString("countryPrefixArray", comment: "")  as String
            
        default:
            break
        }
        self.lblTitle.text = text
        self.lblTitle.sizeToFit()
        
        if self.mode != "Radius"{
            self.tableList.insertObject(chooseOption, atIndex: 0)
            self.selectionsArry.insert(chooseOption, atIndex: 0)
        }else{
            //FIXME:prefix
            if self.mode=="countryPrefixArray" || self.mode=="Language"
            {
                //               self.selectionsArryKey.insert(self.tableList.objectAtIndex(self.tableList.count - 1) as! KeyValue, atIndex: 0)
            }
            else
            {
                //            self.tableView(self.tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: self.tableList.count - 1, inSection: 0)) //CRASH THE APP!!!
                self.selectionsArry.insert(self.tableList.objectAtIndex(self.tableList.count - 1) as! CodeValue, atIndex: 0)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("PopUpTableViewCell") as? PopUpTableViewCell
        cell!.frame = CGRectMake(cell!.frame.origin.x, cell!.frame.origin.y, self.tableView.frame.size.width, cell!.frame.size.height)
        cell!.setSubviewsframes()
        
        //FIXME:prefix
        if self.mode == "countryPrefixArray"
        {
            if countryPrefixArray.count==214
            {
                self.countryPrefixArray.removeObjectAtIndex(0)
            }
            //  println( tableList.objectAtIndex(indexPath.row) as! KeyValue)
            
            let keyVal = tableList.objectAtIndex(indexPath.row) as! KeyValue
            cell!.lblTitle.text = keyVal.nvValue
            cell!.lblPrefix.text = "+"+keyVal.nvValueParam+"   "
            cell!.img.hidden = true
            cell!.lblTitle.textAlignment = NSTextAlignment.Left
            if (self.selectionsArryKey as NSArray).containsObject(keyVal)
            {
                cell!.img.image = UIImage(named: "switchOn.png")
            }
            else{
                cell!.img.image = nil
            }
            //    }
            
        }
        else if self.mode == "Language"
            
        {
            if languageArry.count==92
            {
                self.languageArry.removeObjectAtIndex(0)
            }
            
            
            let keyVal = tableList.objectAtIndex(indexPath.row) as! KeyValue
            cell!.lblTitle.text = keyVal.nvValue
            cell!.lblTitle.textAlignment = NSTextAlignment.Left
            if (self.selectionsArryKey as NSArray).containsObject(keyVal){
                cell!.img.image = UIImage(named: "switchOn.png")
            }else{
                cell!.img.image = nil
            }
            
        }
            
        else
        {
            let codeVal = tableList.objectAtIndex(indexPath.row) as! CodeValue
            
            cell!.lblTitle.text = codeVal.nvValue
            cell!.lblTitle.textAlignment = NSTextAlignment.Left
            
            if (self.selectionsArry as NSArray).containsObject(codeVal)
            {
                cell!.img.image = UIImage(named: "switchOn.png")
            }
            else
            {
                cell!.img.image = nil
            }
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as! PopUpTableViewCell
        //FIXME:prefix
        if self.mode == "countryPrefixArray"
        {
            let keyVal = tableList.objectAtIndex(indexPath.row) as! KeyValue
            self.selectionsArryKey.removeAll(keepCapacity: false)//removeAllObjects()
            self.selectionsArryKey.append(keyVal)
            
            
        }
        else  if self.mode == "Language"
        {
            //            if self.degel < 3
            //            {
            
            let keyVal = tableList.objectAtIndex(indexPath.row) as! KeyValue
            if contains(selectionsArryKey, keyVal)
            {
                degel--
                currentCell.img.image = nil
                self.selectionsArryKey.removeObject(keyVal)
            }
            else
            {
                if self.degel < 3
                {
                    degel++
                    currentCell.img.image = UIImage(named: "switchOn.png")!
                    self.selectionsArryKey.append(keyVal)
                }
                else
                {
                    var alert = UIAlertController(title: "Messege", message: "You can't choose more then 3 languages", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
            
            for (index, element) in enumerate(self.selectionsArry){
                if element.iKeyId == -1{
                    self.selectionsArry.removeAtIndex(index)//removeObjectAtIndex(index)
                    break
                }
            }
            //            }
            //            else
            //            {
            //                var alert = UIAlertController(title: "Messege", message: "You can't choose more then 3 languages", preferredStyle: UIAlertControllerStyle.Alert)
            //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            //                self.presentViewController(alert, animated: true, completion: nil)
            //            }
            
            
        }
        else
        {
            
            let codeVal = tableList.objectAtIndex(indexPath.row) as! CodeValue
            
            var selectionType = self.selectionType()
            if selectionType == 2{
                if (self.selectionsArry as NSArray).containsObject(codeVal){
                    currentCell.img.image = nil
                    //                (self.selectionsArry as! NSArray).delete(codeVal)
                    self.selectionsArry.removeObject(codeVal)
                    if self.selectionsArry.count == 0 {
                        self.selectionsArry.insert(chooseOption, atIndex: 0)//insertObject(chooseOption, atIndex: 0)
                    }
                }else{
                    currentCell.img.image = UIImage(named: "switchOn.png")!
                    self.selectionsArry.append(codeVal)
                    
                    for (index, element) in enumerate(self.selectionsArry){
                        if element.iKeyId == -1{
                            self.selectionsArry.removeAtIndex(index)//removeObjectAtIndex(index)
                            break
                        }
                    }
                }
            }else if selectionType == 1{
                self.selectionsArry.removeAll(keepCapacity: false)//removeAllObjects()
                self.selectionsArry.append(codeVal)
                
            }
        }
        self.tableView.reloadData()
    }
    
    func selectionType() -> Int{
        var selectionType: Int = Int()
        if self.parentView.isKindOfClass(ProfileRegisterViewController) || self.parentView.isKindOfClass(UserProfileViewController){
            if tableList == ApplicationData.sharedApplicationDataInstance.languageArry{
                selectionType = 2
            }else{
                selectionType = 1
            }
        }else{
            switch tableList {
            case ApplicationData.sharedApplicationDataInstance.languageArry:
                selectionType = 2 // multi selection
                break
            case ApplicationData.sharedApplicationDataInstance.countriesArry:
                selectionType = 2
                break
            case ApplicationData.sharedApplicationDataInstance.ageRangeArry:
                selectionType = 1 // single selection
                break
            case ApplicationData.sharedApplicationDataInstance.gendersArry:
                selectionType = 1
                break
            case ApplicationData.sharedApplicationDataInstance.religionsArry:
                selectionType = 1
                break
            case ApplicationData.sharedApplicationDataInstance.religionLevelArry:
                selectionType = 1
                break
            case ApplicationData.sharedApplicationDataInstance.radiusArry:
                selectionType = 1
                break
            default:
                selectionType = 2 // only for countries
                break
            }
        }
        
        return selectionType
    }
    
    @IBAction func btnApplyClicked(sender: AnyObject) {
        if (self.delegate != nil){
            //FIXME:prefix
            if self.mode=="countryPrefixArray"
            {
                self.delegate?.didEndSelectionKey(self.selectionsArryKey, mode: self.mode)
            }
            if self.mode=="Language"
            {
                self.delegate?.didEndSelectionKey(self.selectionsArryKey, mode: self.mode)
                
            }
                
            else
            {
                self.delegate?.didEndSelection(self.selectionsArry, mode: self.mode)
            }
        }
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar){
        println("searchBarResultsListButtonClicked")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        println("textDidChange")
        
        if self.mode == "Countries"{
            tableList.removeAllObjects()
            if searchText == "" || searchText == "\n"{
                tableList = (self.countriesArry.mutableCopy() as! NSMutableArray)
            }else{
                if self.countriesArry.count > 0{
                    for i in 0...self.countriesArry.count - 1{
                        let codeVal = self.countriesArry.objectAtIndex(i) as! CodeValue
                        var curString = codeVal.nvValue
                        var substringRange: NSRange = (curString as NSString).rangeOfString(searchText)
                        if (substringRange.location == 0) {
                            tableList.addObject(codeVal)
                        }
                    }
                }
                
                
            }
            self.tableList.insertObject(chooseOption, atIndex: 0)
            self.tableView.reloadData()
        }
        
        
    }
}
extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}