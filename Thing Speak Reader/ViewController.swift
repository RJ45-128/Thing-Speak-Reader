//
//  ViewController.swift
//  Thing Speak Reader
//
//  Created by Ratnesh Jain on 23/05/16.
//  Copyright © 2016 ecosmob. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let READ_API_KEY = "R49YCNNYT941ZQUW"
    
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelNameField: UILabel!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldNameField: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var jsonResult: NSDictionary!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
        callAPI()
//        updateLabels()
    }
    
    func callAPI(){
     
        let url = "https://api.thingspeak.com/channels/118513/feed.json?key=\(READ_API_KEY)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
           
            do {
                
                let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                self.jsonResult = jsonDict
                
            } catch let error as NSError {
                
                print(error)
                
            }
            self.performSelector(#selector(self.updateLabels), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
            self.performSelector(#selector(self.updateLabels), onThread: <#T##NSThread#>, withObject: <#T##AnyObject?#>, waitUntilDone: <#T##Bool#>)
        }
        task.resume()
        
    }
    
    func updateLabels(){
        
         print("\(self.jsonResult)")
        self.fieldNameLabel.text = self.jsonResult["channel"]!["field1"] as? String
        self.channelNameField.text = self.jsonResult["channel"]!["name"] as? String
        
        let array = self.jsonResult["feeds"]
        if let count = array?.count {
            self.fieldNameField.text = array![count-1]["field1"] as? String
        }
//        advanceArray()
        
        }
    
     func advanceArray(){
        let array = self.jsonResult["feeds"]
        self.fieldNameField.text = array![i]["field1"] as? String
        i += 1
        if i == array?.count {
            i = 0
        }
        self.performSelector(#selector(advanceArray), withObject: self, afterDelay: 1.0)
    }

}

