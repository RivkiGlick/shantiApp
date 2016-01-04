//
//  FileManager.swift
//  Shanti
//
//  Created by hodaya ohana on 6/17/15.
//  Copyright (c) 2015 webit. All rights reserved.
//

import UIKit

private let sharedFileManager = FileManager()
class FileManager: NSObject {
    private let fileManager = NSFileManager()
    private let tmpDir = NSTemporaryDirectory()
    private let fileName = "attachments.txt"
    
    class var sharedInstace: FileManager{
        return sharedFileManager
    }
    
    func enumerateDirectory() -> String? {
        var error: NSError?
        let filesInDirectory = fileManager.contentsOfDirectoryAtPath(tmpDir, error:  &error) as? [String]
        
        if let files = filesInDirectory {
            if files.count > 0 {
                for file in files{
                    println("file: \(file)")
                }
                if files[0] == fileName {
                    println("\(fileName) found")
                    return files[0]
                } else {
                    println("File not found")
                    return self.createFile()
                }
            }else {
                println("File not found")
                return self.createFile()
            }
        }else{
            println("error")
        }
        return nil
    }
    
    func viewFileContent() -> NSDictionary?{
        let isFileInDir = enumerateDirectory() ?? ""
        
        let path = tmpDir.stringByAppendingPathComponent(isFileInDir)
        let contentsOfFile = NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)//NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        
        if let content = contentsOfFile {
            if content.length > 0{
                println("Content of file = \(content)")
                var myDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(content) as! NSDictionary
                println("myDictionary = \(myDictionary)")
                return myDictionary
            }
            return nil
        } else {
            println("No file found")
            return nil
        }
    }
    
    func createFile() -> String?{
        let path = tmpDir.stringByAppendingPathComponent(fileName)
        let contentsOfFile = ""
        var error: NSError?
        
        // Write File
        if contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error) == false {
            if let errorMessage = error {
                println("Failed to create file")
                println("\(errorMessage)")
                return nil
            }
        } else {
            println("\(fileName) created at tmp directory")
            return fileName
        }
        
        return nil
    }
    
    func writeIntoFile(key: String, value: String) -> NSMutableDictionary{
        var newDict = self.viewFileContent()
        
        if newDict == nil{
            println("newDict nil")
            
            var dict = NSMutableDictionary()
            dict.setObject(value, forKey: key)
            var jsonData: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
            fileManager.createFileAtPath(tmpDir.stringByAppendingPathComponent(fileName), contents: jsonData, attributes: nil)
            
            var newDict1 = self.viewFileContent()
            if newDict1 == nil{
                println("newDict1 nil")
                return NSMutableDictionary()
            }else{
                println("newDict1 :\(newDict1!)")
                return NSMutableDictionary(dictionary: newDict1!)
            }

            
        }else{
            println("newDict:\(newDict!)")
            var dict = NSMutableDictionary(dictionary: newDict!)
            dict.setObject(value, forKey: key)
            var jsonData: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
            fileManager.createFileAtPath(tmpDir.stringByAppendingPathComponent(fileName), contents: jsonData, attributes: nil)
            
            var newDict1 = self.viewFileContent()
            if newDict1 == nil{
                println("newDict1 nil")
                return NSMutableDictionary()
            }else{
                println("newDict1 :\(newDict1!)")
                return NSMutableDictionary(dictionary: newDict1!)
            }
            
        }
    
    }
}
