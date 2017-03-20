//
//  ViewController.swift
//  midraffler
//
//  Created by LINE on 3/7/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var isStarted = false
    var rndTimer = Timer()
    var midRaffler:MidRaffler?
    var luckyUser:LineUser?
    
    @IBOutlet weak var midTextField: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask=0x1
        gesture.numberOfClicksRequired=1
        gesture.target=self
        gesture.action=#selector(ViewController.onMidClick)
        midTextField.addGestureRecognizer(gesture)
        
        midTextField.stringValue="Hello!"
    }
    
    override func viewDidAppear()
    {
        let presOpt: NSApplicationPresentationOptions = ([.autoHideDock,.autoHideMenuBar])
        let optDict = [NSFullScreenModeApplicationPresentationOptions : NSNumber(value: presOpt.rawValue)]
        
        self.view.enterFullScreenMode(NSScreen.main()!, withOptions: optDict)
        self.view.wantsLayer = true
    }
    
    @IBAction func onStartClick(_ sender: NSButton)
    {
        print("onStartClick - start")
        
        if midRaffler == nil
        {
            showMessage(message: "Please select [File] -> [Open] to load the base directory")
            return
        }
        else
        {
            if isStarted == false
            {
                luckyUser = midRaffler!.draw()
                print("onStartClick - lucky mid: \(luckyUser!.mid)")
                runAuto()
            }
        }
    }
    
    func onMidClick(sender: NSGestureRecognizer)
    {
        if(luckyUser != nil && isStarted==false)
        {
            showMessage(message: "MID: \(luckyUser!.mid)\nUsername: \(luckyUser!.username)")
        }
    }
    
    @IBAction func onEndClick(_ sender: NSButton)
    {
        print("onEndClick - start")
        
        if isStarted == false
        {
            print("onEndClick - isStarted: false")
            showMessage(message: "Please start the raffle first!")
            return
        }
        else
        {
            print("onEndClick - isStarted: true - mid: \(luckyUser!.mid)")
        
            rndTimer.invalidate()
            isStarted = false
            midTextField.stringValue = luckyUser!.mid
        }
    }
        
    // make timer and run randomMid func every 0.125s
    func runAuto()
    {
        isStarted = true
        rndTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ViewController.randomiseMid), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear()
    {
        print("viewWillDisappear - start")
        if midRaffler != nil
        {
            midRaffler!.free()
        }
        
        super.viewWillDisappear()
    }
    
    // wrap show message
    func showMessage(message: String)
    {
        let alert=NSAlert()
        alert.messageText=message
        alert.runModal()
    }
    
    // reinitialise base directory
    func loadBaseDir(dir: String)
    {
        midRaffler=MidRaffler(fromBaseDir: dir)
        midTextField.stringValue="Hello!"
    }
    
    // randomise mid
    func randomiseMid()
    {
        let dummyMid=midRaffler!.generateDummyMid()
        midTextField.stringValue=dummyMid
    }
}


