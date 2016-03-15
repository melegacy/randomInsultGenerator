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

class ViewController: UIViewController {
    
    @IBOutlet weak var InsultLabel: UILabel!
    @IBOutlet weak var tapOrShake: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set light status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //single tap generates insult
        let tap1 = UITapGestureRecognizer(target: self, action: "generateInsult")
        tap1.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap1)
        
        
        //double tap clears the screen
        let tap2 = UITapGestureRecognizer(target: self, action: "doubleTapped")
        tap2.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap2)
        
        tapOrShake.hidden = false
    }
    
    func doubleTapped() {
        InsultLabel.text = ""
        tapOrShake.hidden = false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //change insult label using random parts
//        InsultLabel.text = ((beginningString[randomNumber1]) + " " + (middleString[randomNumber2]) + " " + (endString[randomNumber3] + "!"))
//        tapOrShake.hidden = true
        
       
        tapOrShake.hidden = true
        asYoda("an%20insult%20goes%20here")
    }
    
    
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

    //TRANSLATION API
    //MARK: - REST calls
    // This makes the GET call to httpbin.org. It simply gets the IP address and displays it on the screen.
    func asYoda(yodaInsult: String) {
        
        var translatedString: String = ""
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = ("https://www.googleapis.com/language/translate/v2?key=AIzaSyA262UJdmaDvR8pCsXMB35qQd_DR1p82YQ&source=en&target=de&q=" + (yodaInsult))

        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let yodaString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    //print(yodaString)
 
                    // Parse the JSON to get the yoda insult
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let translated = jsonDictionary["data"]!["translations"]!![0]["translatedText"] as! String
                    //print (translated)
                    
                    translatedString = translated
                    print (translatedString)
                    
                    // Update the label
                    //self.InsultLabel.text = translated
                    //self.performSelectorOnMainThread("InsultLabel", withObject: translated, waitUntilDone: false)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                      self.InsultLabel.text = translated
                    })
                }
            } catch {
                print("bad things happened")
            }
            
        }).resume()
        //return translatedString
        //print (translatedString)
    }
}




