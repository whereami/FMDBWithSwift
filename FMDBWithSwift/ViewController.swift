//
//  ViewController.swift
//  Database
//
//  Created by 오세봉 on 2014. 6. 15..
//  Copyright (c) 2014년 오세봉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var databasePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let docDirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        databasePath = docDirPath.stringByAppendingPathComponent("contact.db")
        
        let fileMgr = NSFileManager.defaultManager()
        
        if !fileMgr.fileExistsAtPath(databasePath) {
            let db = FMDatabase(path: databasePath)
            if db.open() {
                db.executeUpdate("CREATE TABLE IF NOT EXISTS CONTACTS " +
                    "( ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    " NAME TEXT, " +
                    " ADDRESS TEXT, " +
                    " PHONE TEXT)", withArgumentsInArray: nil)
                if db.hadError() {
                    let error = db.lastError()
                    label.text = error.localizedDescription
                }
                
                db.close()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var label : UILabel
    @IBOutlet var nameField : UITextField
    @IBOutlet var addressField : UITextField
    @IBOutlet var phoneField : UITextField
    
    @IBAction func onSave(sender : UIButton) {
        let db = FMDatabase(path: databasePath)
        if db.open() {
            
            let name: NSString = nameField.text
            let address: NSString  = addressField.text
            let phone: NSString = phoneField.text
            
            db.executeUpdate("INSERT INTO CONTACTS(NAME, ADDRESS, PHONE) VALUES(?, ?, ?)", withArgumentsInArray: [name, address, phone])
            
            if db.hadError() {
                let error = db.lastError()
                label.text = error.localizedDescription
            } else {
                label.text = name as String + " Saved"
            }
            
            db.close()
        }
    }
    
    @IBAction func onFind(sender : UIButton) {
        let db = FMDatabase(path: databasePath)
        if db.open() {
            
            let name: NSString = nameField.text
            
            let resultSet = db.executeQuery("SELECT ADDRESS, PHONE FROM CONTACTS WHERE NAME = ? ", withArgumentsInArray: [name])
            
            if resultSet {
                while resultSet.next() {
                    addressField.text = resultSet.stringForColumn("ADDRESS")
                    phoneField.text = resultSet.stringForColumn("PHONE")
                }
            }
            
            if db.hadError() {
                let error = db.lastError()
                label.text = error.localizedDescription
            } else {
                label.text = name as String + " Found"
            }
            
            db.close()
        }
    }
}

