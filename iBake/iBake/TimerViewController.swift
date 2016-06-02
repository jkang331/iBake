//
//  TimerViewController.swift
//  iBake
//
//  Created by iGuest on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController{

    @IBOutlet weak var Navbar: UINavigationBar!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    @IBOutlet weak var timerPicker: UIDatePicker!
    
    @IBOutlet weak var stepLabel: StepLabel!
    var instruction :String?
    var recipeName : String?
    
    var startingTime = NSTimeInterval(2)
    var elapsedTime = NSTimeInterval()
    var seconds = 0
    var minutes = 0
    var hours = 0
    var timer = NSTimer();
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func resetPressed(sender: AnyObject) {
        timer.invalidate()
        startingTime = timerPicker.countDownDuration
        
        elapsedTime = startingTime;
        let interval = Int(elapsedTime)
        hours = interval / 3600
        minutes = (interval / 60) % 60
        seconds = interval % 60
        
        timerLabel.text = formatTime()
        pauseButton.enabled = false
        playButton.enabled = true
        timerPicker.userInteractionEnabled = true
    }
    
    @IBAction func playPressed(sender: AnyObject) {
            let aSelector : Selector = #selector(TimerViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
            playButton.enabled = false
            pauseButton.enabled = true
            timerPicker.userInteractionEnabled = false
    }
    
    
    @IBAction func pausePressed(sender: AnyObject) {
        timer.invalidate()
        pauseButton.enabled = false
        playButton.enabled = true
        timerPicker.userInteractionEnabled = true
    }
    
    
    func updateTime() {
        elapsedTime -= 1 //this should take off a second
        
        if (elapsedTime > -1 ) {
            let interval = Int(elapsedTime)
            hours = interval / 3600
            minutes = (interval / 60) % 60
            seconds = interval % 60
        
            timerLabel.text = formatTime()
            
        } else {
            timer.invalidate()
            
            let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ding", ofType: "mp3")!)
            
            do{
                audioPlayer = try AVAudioPlayer.init(contentsOfURL: alertSound)
            } catch{
                print(error)
            }
            
            
            
            audioPlayer.numberOfLoops = -1;
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            let timerDoneAlert = UIAlertController(title: "Go check on your dessert!", message:"hurrrrryyyyyy", preferredStyle: .Alert)
            
            let doneAction = UIAlertAction(title:"Done", style:.Default) {(action) in self.audioPlayer.stop()};
            timerDoneAlert.addAction(doneAction)
            self.presentViewController(timerDoneAlert, animated: true) {}
            timerPicker.userInteractionEnabled = true
            
            
        }
    
    }
    
    
    

    
    private func formatTime() -> String {
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        return strHours + ":" + strMinutes + ":" + strSeconds

    }
    
    func updateLabel(datePicker: UIDatePicker) {
        playButton.enabled = true
        elapsedTime = timerPicker.countDownDuration;
        let interval = Int(elapsedTime)
        hours = interval / 3600
        minutes = (interval / 60) % 60
        seconds = interval % 60
        
        timerLabel.text = formatTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navbar.topItem!.title = recipeName!
        stepLabel.text = instruction!
        
        
        timerPicker.datePickerMode = UIDatePickerMode.CountDownTimer
        let aSelector : Selector = #selector(TimerViewController.updateLabel)
        timerPicker.addTarget(self, action: aSelector, forControlEvents: UIControlEvents.ValueChanged)
        
//        startingTime = timerPicker.countDownDuration
        
        elapsedTime = startingTime;
        let interval = Int(elapsedTime)
        hours = interval / 3600
        minutes = (interval / 60) % 60
        seconds = interval % 60
        
        timerLabel.text = formatTime()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
