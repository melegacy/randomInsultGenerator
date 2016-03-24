//
//  ViewController.swift
//  RandomInsultGenerator
//
//  Created by Melissa Allgeier on 2/16/16.
//  Copyright © 2016 Melissa Allgeier. All rights reserved.
//
//
//  TO DO:
//  add compliment functionality
//  add questions vs statements
//      character on front of string?
//  insult needs %20 for spaces
//  need translate button/toggle
//  need all API stuff inside button function
//  fix yoda/remove unused variables
//  can we create a global "translated" variable? or return variable somehow?
//
//
//





import UIKit
import Foundation
import TwitterKit

class ViewController: UIViewController {
    
    @IBOutlet weak var InsultLabel: UILabel!
    @IBOutlet weak var tapOrShake: UILabel!
    @IBOutlet weak var changeLanguage: UISegmentedControl!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set light status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //single tap generates insult
        let tap1 = UITapGestureRecognizer(target: self, action: "generateInsult")
        tap1.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap1)
        
        tapOrShake.hidden = false
        
    }

    
    //allows shakes to be recognized
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    //generate insult on shake
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            generateInsult()
        }
    }
    
    
    func generateInsult() {
        //unpack plist
        let path = NSBundle.mainBundle().pathForResource("Insults", ofType: "plist")
        //put plist info into dictionary
        let dict = NSDictionary(contentsOfFile: path!)
        
        //assign objects in dictionary to string in an array
        let beginningString = dict!.objectForKey("BeginningString") as! [String]
        let middleString = dict!.objectForKey("MiddleString") as! [String]
        let endString = dict!.objectForKey("EndString") as! [String]
        
        //generate random numbers
        let randomNumber1 = Int(arc4random_uniform(UInt32(beginningString.count)))
        let randomNumber2 = Int(arc4random_uniform(UInt32(middleString.count)))
        let randomNumber3 = Int(arc4random_uniform(UInt32(endString.count)))
        
        let originalInsult = ((beginningString[randomNumber1]) + " " + (middleString[randomNumber2]) + " " + (endString[randomNumber3] + "!"))
        
        //change insult label using random parts
        InsultLabel.text = originalInsult
        tapOrShake.hidden = true
        
    }
    
    
    
    
    //Share button
    @IBAction func ShareButton(sender: UIButton) {
        // Check and see if the text field is empty
        if (InsultLabel.text == "") {
            // The text field is empty so display an Alert
            displayAlert("Warning", message: "You need do generate an insult first!")
        } else {
            // We have contents so display the share sheet
            displayShareSheet(InsultLabel.text!)
        }
    }
    
    //sharing alert
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }

    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }

    
    //tranlation button
//    @IBAction func changeLanguageAction(sender: AnyObject) {
//        if(changeLanguage.selectedSegmentIndex == 0) {
//            //do nothing
//        } else if (changeLanguage.selectedSegmentIndex == 1) {
//            //translate to spanish
//        } else if (changeLanguage.selectedSegmentIndex == 2) {
//            //translateInsultGerman(originalInsult)
//        }
//    }
    
    
    
    
    //TRANSLATION API
    //MARK: - REST calls
    // This makes the GET call to google translate. 
    
//    func translateInsultGerman(insult: String) {
//        
//       
//        let originalUrl = ("https://www.googleapis.com/language/translate/v2?key=AIzaSyADNcayNHrDCbM3Yf5GuZ09mTtTq1-ORtM&source=en&target=de&q=" + "originalInsult")
//        let  urlString :String = originalUrl.stringByRemovingPercentEncoding!
//        
//        let postEndpoint: String = urlString
//        let url = NSURL(string: postEndpoint)!
//        
//        //print("\(originalInsult)")
//        //print("\(url)")
//        
//        let session = NSURLSession.sharedSession()
//        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//        
//            // Read the JSON
//            do {
//                if let insultString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
// 
//                    // Parse the JSON to get the translated insult
//                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                    
//                    print("\(jsonDictionary)")
//                    
//                    if let translated = jsonDictionary["data"]!["translations"]!![0]["translatedText"] as! String? {
//                        //Update the label
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.InsultLabel.text = translated
//                        })
//                       // print("\(translated)")
//                    } else {
//                        print("error")
//                    }
//                    
//                    //let translated = jsonDictionary["data"]!["translations"]!![0]["translatedText"] as! String
//                    
//                }
//            } catch {
//                print("bad things happened")
//            }
//            
//        }).resume()
//    }
//}
//
//

}
