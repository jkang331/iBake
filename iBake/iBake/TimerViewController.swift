//
//  TimerViewController.swift
//  iBake
//
//  Created by iGuest on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController{

    @IBOutlet weak var Navbar: UINavigationBar!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    @IBOutlet weak var stepLabel: StepLabel!
    var instruction :String?
    
//    var startTime = NSTimeInterval()
    var startingTime = NSTimeInterval(2)
    var elapsedTime = NSTimeInterval()
    var seconds = 0
    var minutes = 0
    var hours = 0
    var timer = NSTimer();
    var doneBlinkerTimer = NSTimer();
    var blinkStatus = false
    
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func resetPressed(sender: AnyObject) {
        timer.invalidate()
        elapsedTime = startingTime;
        let interval = Int(elapsedTime)
        hours = interval / 36000
        minutes = (interval / 60) % 60
        seconds = interval % 60
        
        timerLabel.text = formatTime()
        pauseButton.enabled = false
        playButton.enabled = true
        doneBlinkerTimer.invalidate()
    }
    
    @IBAction func playPressed(sender: AnyObject) {
            let aSelector : Selector = #selector(TimerViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
            playButton.enabled = false
            pauseButton.enabled = true
    }
    
    
    @IBAction func pausePressed(sender: AnyObject) {
        timer.invalidate()
        pauseButton.enabled = false
        playButton.enabled = true
    }
    
    
    func updateTime() {
        elapsedTime -= 1 //this should take off a second
        
        if (elapsedTime > -1 ) {
            let interval = Int(elapsedTime)
            hours = interval / 36000
            minutes = (interval / 60) % 60
            seconds = interval % 60
        
            timerLabel.text = formatTime()
            
        } else {
            timer.invalidate()
            timerLabel.text = timerLabel.text! + "\nDONE!!!"
            let aSelector : Selector = #selector(TimerViewController.doneBlinkLabel)
            doneBlinkerTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: aSelector, userInfo: nil, repeats:true)
        }
    
    }
    
    
    // NOTE: don't really like this blinking maybe add sound effect instead?
    func doneBlinkLabel() {
        if(blinkStatus){
            timerLabel.textColor = UIColor.clearColor()
            blinkStatus = false
        } else {
            timerLabel.textColor = UIColor.blackColor()
            blinkStatus = true
        }
    }
    
    private func formatTime() -> String {
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        return strHours + ":" + strMinutes + ":" + strSeconds

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = instruction!
        
        elapsedTime = startingTime;
        let interval = Int(elapsedTime)
        hours = interval / 36000
        minutes = (interval / 60) % 60
        seconds = interval % 60
        
        timerLabel.text = formatTime()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
