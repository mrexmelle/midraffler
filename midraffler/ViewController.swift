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
    var baseDir: String?
    var resFile: String?
    let fileMgr = FileManager.default
    var rndTimer = Timer()
    var midResult: String?
    var userDetail: String?
    var fileCount: Int = 0
    var resArray = [String]()

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
    }
    
    @IBAction func onStartClick(_ sender: NSButton)
    {
        print("onStartClick - start")
        
        if baseDir == nil
        {
            showMessage(message: "Please select [File] -> [Open] to load the base directory")
            return
        }
        
        midResult = getMidFromFiles()
        print("onStartClick - midResult: \(midResult)")
        if isStarted == false
        {
            runAuto()
        }
    }
    
    func onMidClick(sender: NSGestureRecognizer)
    {
        if userDetail != nil
        {
            showMessage(message: userDetail!)
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
        
         print("onEndClick - isStarted: true - mid: \(midResult)")
        
        rndTimer.invalidate()
        isStarted = false
        midTextField.stringValue = midResult!
    }
    
    // pick random MID from Files
    func getMidFromFiles() -> String
    {
        print("getMidFromFiles - start")
    
        // pick a random file
        let randomFile:Int = randomNumber(n: fileCount) + 1
            
        let filePath:String = baseDir! + "/testing-" + String(randomFile) + ".csv"
        print(filePath)
            
        // check file exist or not
        if fileMgr.fileExists(atPath: filePath)
        {
            print("getMidFromFiles - \(filePath) exists")
        }
        else
        {
            print("getMidFromFiles - \(filePath) does not exist")
            return " "
        }
        
        // count lines in the random file
        print("getMidFromFiles - start counting lines")
        let databuffer = fileMgr.contents(atPath: filePath)
        let data = String(data: databuffer!, encoding: .utf8)
        var myStrings = data?.components(separatedBy: .newlines)
        print("getMidFromFiles - counting lines ended")
        print("nLines: " + String((myStrings!.count)))
        
        var randomIndex: Int = 0
        
        print(resArray)
        // repeat pick random line until line does not exist in array
        repeat
        {
            // Pick a random line
            randomIndex = randomNumber(n: (myStrings!.count))
            print("Pick one random number for lines")
            print("Data: " + (myStrings?[randomIndex])!)
        }
        while resArray.contains((myStrings?[randomIndex])!)
        
        resArray.append((myStrings?[randomIndex])!)
        print("getMidFromFiles - regsitered mid: \(resArray.last)")
        
        // parse line to be a result
        let results = (myStrings?[randomIndex])!.components(separatedBy: ",")
        let resultString = results[0]
        userDetail = ""
        for data in results
        {
            userDetail = userDetail! + data + "\n"
        }
        print("Result: " + resultString)
        
        return String(resultString)
    }
    
    // generate random number
    func randomNumber(n: Int) -> Int
    {
        let randomFileNum:UInt32 = arc4random_uniform(UInt32(n))
        let randomNum:Int = Int(randomFileNum)
        return randomNum
    }
    
    // make timer and run randomMid func every 0.125s
    func runAuto()
    {
        isStarted = true
        rndTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ViewController.randomiseMid), userInfo: nil, repeats: true)
    }
    
    // generate random MID and change UI Label
    func randomiseMid()
    {
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
    
    // reinitialise base directory
    func loadBaseDir(dir: String)
    {
        baseDir=dir
        resFile=baseDir!+"/results.txt"
        
        print("loadBaseDir - baseDir: \(baseDir)")
        print("loadBaseDir - resFile: \(resFile)")
        
        do
        {
            // count existing files
            NSLog("Start counting files")
            fileCount = try fileMgr.contentsOfDirectory(atPath: baseDir!).filter{ $0.hasPrefix("testing") }.count
            NSLog("Counting files ended")
            print("fileCount: \(fileCount)")
            
            // check file exist or not
            if fileMgr.fileExists(atPath: resFile!)
            {
                // contain file's data in an array
                let resFileBuffer = fileMgr.contents(atPath: resFile!)
                let resultData = String(data: resFileBuffer!, encoding: .utf8)
                resArray = (resultData?.components(separatedBy: .newlines))!
                print(resArray)
            }
            else
            {
                fileMgr.createFile(atPath: resFile!, contents: Data())
            }
        }
        catch
        {
            print("loadBaseDir - error: \(error)")
        }
        
        midTextField.stringValue = "Hello"
        midResult=""
    }

    override func viewWillDisappear()
    {
        // save results to file
        let joinedResult = resArray.joined(separator: "\n")
        do
        {
            print("viewWillDisappear - resFile: \(resFile)")
            // nil means, no baseDir ever defined
            if resFile != nil
            {
                try(joinedResult.write(toFile: resFile!, atomically: false, encoding: .utf8))
            }
        }
        catch
        {
            print (error)
        }
        print(resArray)
        print("viewWillDisappear - exit")
    }
    
    func showMessage(message: String)
    {
        let alert=NSAlert()
        alert.messageText=message
        alert.runModal()
    }
}


