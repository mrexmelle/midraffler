//
//  ViewController.swift
//  midraffler
//
//  Created by LINE on 3/7/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var pathString: String?
    let fm = FileManager.default
    var myTimer = Timer()
    var midResult: String = ""
    

    @IBOutlet weak var midTextField: NSTextField!
    
    @IBAction func onStartClick(_ sender: NSButton)
    {
        print("Start")
        midResult = getMidFromFiles()
        runCountdown()
    }
    
    @IBAction func onEndClick(_ sender: NSButton)
    {
        print("Stop")
        myTimer.invalidate()
        midTextField.stringValue = midResult
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if CommandLine.argc > 1
        {
            pathString=CommandLine.arguments[1];
        }
        else
        {
            pathString=""
        }
    }
    
    func getMidFromFiles() -> String {
        
        do {
            let nFiles:Int = try fm.contentsOfDirectory(atPath: pathString!).filter{ $0.hasPrefix("test") }.count
            let randomFileNum:UInt32 = arc4random_uniform(UInt32(nFiles))
            let randomFile:Int = Int(randomFileNum) + 1
            
            let filePath:String = pathString! + "/test-" + String(randomFile) + ".txt"
            
            //Check file exist or not
            if fm.fileExists(atPath: filePath) {
                print("File exists")
            } else {
                print("File not found")
            }
            
            let databuffer = fm.contents(atPath: filePath)
            let data = String(data: databuffer!, encoding: .utf8)
            var myStrings = data?.components(separatedBy: "\n")
            let randomIndexNum:UInt32 = arc4random_uniform(UInt32(myStrings!.count))
            let randomIndex:Int = Int(randomIndexNum)
            print("Data: " + (myStrings?[randomIndex])!)
            
            return (myStrings?[randomIndex])!
        } catch {
            print(error)
            return " "
        }
    }
    
    func runCountdown() {
        myTimer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector:#selector(ViewController.randomMid), userInfo: nil, repeats: true)
    }
    
    func randomMid() {
        let seeds : String = "qwertyuiopasdfghjklzxcvbnm1234567890";
        let len = seeds.characters.count;
        
        var mid="u";
        
        for _ in 0 ..< 32
        {
            let rand = Int(arc4random_uniform(UInt32(len)));
            let idx = seeds.index(seeds.startIndex, offsetBy: rand);
            let nextChar = seeds[idx];
            mid += String(nextChar);
        }
        
        midTextField.stringValue = "\(mid)"
    }
}


