//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Jesus Lopez de Nava on 7/13/15.
//  Copyright (c) 2015 LodenaApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userCity: UITextField!

    @IBOutlet var resultLabel: UILabel!

    @IBAction func textFieldGotFocus(sender: AnyObject) {

        userCity.text = nil
        
        self.resultLabel.backgroundColor = nil
        
        resultLabel.text = nil

    }
    
    @IBAction func searchWeather(sender: AnyObject? = nil) { // <-- when I wrote AnyObject? = nil it means that a parameter is not needed in order to run this method //
        
        var isError = true
        
        userCity.text = userCity.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if userCity.text != "" {
        
            let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
            
            if let url = attemptedUrl {
            
                let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                    
                    if let urlContent = data {
                        
                        let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)!
                        
                        let webSiteArray = webContent.componentsSeparatedByString("<span class=\"phrase\">")
                        
                        if webSiteArray.count > 1 {
                            
                            let weatherArray = webSiteArray[1].componentsSeparatedByString("</span>")
                            
                            if weatherArray.count > 1 {
                                
                                isError = false
                                
                                var weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                                
                                var farenheitWeather = weatherSummary
                                farenheitWeather = farenheitWeather.stringByReplacingOccurrencesOfString("ºC", withString: "ºF")
                                
                                var weatherNS = NSString(string: farenheitWeather)
                                var weatherNSarray = weatherNS.componentsSeparatedByString("max ")
                                //var weatherTemp = weatherNSarray[1]
                                var numericArray = weatherNSarray[1].componentsSeparatedByString("ºF")
                                var theTemp = Int(numericArray[0])
                                var TempFar = Int(round((1.8) * Double(theTemp!) + 32))
                                farenheitWeather = weatherNSarray[0] + "max \(TempFar)ºF" + numericArray[1] + "ºF" + numericArray[2]
                                
                                weatherNS = NSString(string: farenheitWeather)
                                weatherNSarray = weatherNS.componentsSeparatedByString("min ")
                                //weatherTemp = weatherNSarray[1]
                                numericArray = weatherNSarray[1].componentsSeparatedByString("ºF")
                                theTemp = Int(numericArray[0])
                                TempFar = Int(round((1.8) * Double(theTemp!) + 32))
                                farenheitWeather = weatherNSarray[0] + "min \(TempFar)ºF" + numericArray[1]
                                
                                weatherSummary = farenheitWeather
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.resultLabel.backgroundColor = UIColor.whiteColor()
                                    
                                    self.resultLabel.textColor = UIColor.blueColor()
                                    
                                    self.resultLabel.text = weatherSummary
                                    
                                    self.view.endEditing(true)
                                    
                                })
                                
                            }
                        
                        }
                        
                    }
                    
                    if isError {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                         
                            self.resultLabel.textColor = UIColor.redColor()
                            
                            self.resultLabel.backgroundColor = UIColor.whiteColor()
                            
                            self.resultLabel.text = "Was not able to find weather for " + self.userCity.text! + ". Please try again."
                            
                        })
                        
                    }
                    
                }
                
                task?.resume()
                
            } else {
                
                self.resultLabel.textColor = UIColor.redColor()
                
                self.resultLabel.backgroundColor = UIColor.whiteColor()
                
                resultLabel.text = "Sorry, " + userCity.text! + " is not a valid city name. Please try again."
                
            }
        
        } else {
            
            self.resultLabel.textColor = UIColor.redColor()
            
            self.resultLabel.backgroundColor = UIColor.whiteColor()
            
            resultLabel.text = "Please enter a city's name"
            
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.searchWeather() // <-- I can call the button's method programatically without any parameter (sender) because I set it up this way when I declared the method: sender: AnyObject? = nil (see code above)
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.userCity.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

