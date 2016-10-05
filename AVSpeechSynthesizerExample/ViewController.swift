//
//  ViewController.swift
//  AVSpeechSynthesizerExample
//
//  Created by Varun Rathi on 04/10/16.
//  Copyright © 2016 Novoinvent. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var pickerView:UIPickerView!
    @IBOutlet weak var btnSpeak:UIButton!
     @IBOutlet weak var btnStop:UIButton!
     @IBOutlet weak var btnPause:UIButton!
    
    @IBOutlet weak var btnLanguage:UIButton!
    @IBOutlet weak var tfInputText:UITextField!
    var arrDataSource:[String] = []
    var selectedLanguage:String!
    
    
    var rate:Float!
    var pitch:Float!
    var volume:Float!
    
    let speechSynthesizer=AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        if !loadSettings()
        {
            registerDefaultValues()
        }
        
        arrDataSource=[String]()
        arrDataSource.append("English")
        arrDataSource.append("German")
        arrDataSource.append("French")
        arrDataSource.append("Spanish")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.dataSource=self;
        pickerView.delegate=self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        pickerView.delegate=nil
        pickerView.dataSource=nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDataSource.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrDataSource[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            selectedLanguage="English"
        case 1:
            selectedLanguage="German"
            
        case 2:
            selectedLanguage="French"
        case 3:
            selectedLanguage="Spanish"
            
        default:
            selectedLanguage="English"
        }
    }
    
    @IBAction func btnSpeakPressed(sender:AnyObject)
    {
        
        if(!speechSynthesizer.speaking)
        {
        let speechUtterance=AVSpeechUtterance(string: tfInputText.text!)
        speechUtterance.rate=rate
        speechUtterance.volume=volume
        speechUtterance.pitchMultiplier=pitch
        
        speechSynthesizer.speakUtterance(speechUtterance)
        }
        else
        {
            speechSynthesizer.continueSpeaking()
        }
        
    }
    
    func registerDefaultValues()
    {
        rate=AVSpeechUtteranceDefaultSpeechRate
        pitch=1.0
        volume=1.0
        
        let defaultValues:Dictionary<String,AnyObject>=["rate":rate, "pitch":pitch, "volume":volume]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultValues)
    }
    
    func loadSettings()->Bool
    {
    let userDefaults=NSUserDefaults.standardUserDefaults() as NSUserDefaults
        let theRate: Float = userDefaults.valueForKey("rate") as! Float
             do{
            
                rate=theRate
                pitch=userDefaults.valueForKey("pitch") as! Float
                volume=userDefaults.valueForKey("volume") as! Float
                return true
            }
     return false
    }
    
    @IBAction func pauseSpeech(sender:AnyObject)
    {
     speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
     animateButtonAppearance(false)
    }
    
    @IBAction func stopSpeech(sender:AnyObject)
    {
     speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        animateButtonAppearance(false)
    }
    
    func animateButtonAppearance(hideSpeakButton:Bool)
    {
        var speakBtnAlpha:CGFloat=1.0
        var pauseBtnAlpha:CGFloat=0.0
        
        if(hideSpeakButton)
        {
            speakBtnAlpha=0.0
            pauseBtnAlpha=1.0
            
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.btnSpeak.alpha=speakBtnAlpha
            self.btnStop.alpha=pauseBtnAlpha
            self.btnPause.alpha=pauseBtnAlpha
        
        })    }
    
}

