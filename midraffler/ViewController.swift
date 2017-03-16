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
    var pathString: String?
    var resultFile: String = "/Users/line/Documents/workspace/swift/first/midraffler/data/results.txt"
    let fm = FileManager.default
    var myTimer = Timer()
    var midResult: String = ""
    var nFiles: Int = 0
    var resultArray = [String]()

    @IBOutlet weak var midTextField: NSTextField!
    
    @IBAction func onStartClick(_ sender: NSButton)
    {
        print("Start")
        midResult = getMidFromFiles()
        if isStarted == false {
            runAuto()
        }
    }
    
    @IBAction func onEndClick(_ sender: NSButton)
    {
        print("Stop")
        myTimer.invalidate()
        isStarted = false
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
        pathString = "/Users/line/Documents/workspace/swift/first/midraffler/data/"
        
        do{
            // Count existing files
            NSLog("Start counting files")
            let nFiles:Int = try fm.contentsOfDirectory(atPath: pathString!).filter{ $0.hasPrefix("testing") }.count
            NSLog("Counting files ended")
            print("nFiles: " + String(nFiles))
            
            //Check file exist or not
            if fm.fileExists(atPath: resultFile) {
                // Contain file's data in an array
                let resultFileBuffer = fm.contents(atPath: resultFile)
                let resultData = String(data: resultFileBuffer!, encoding: .utf8)
                resultArray = (resultData?.components(separatedBy: .newlines))!
                print(resultArray)
            }
        } catch {
            print(error)
        }
    }
    
    // Pick random MID from Files
    func getMidFromFiles() -> String {
        
        // Pick a random file
        let randomFile:Int = randomNumber(n: nFiles) + 1
        NSLog("Pick one random number for files")
            
        let filePath:String = pathString! + "testing-" + String(randomFile) + ".csv"
        print(filePath)
            
        //Check file exist or not
        if fm.fileExists(atPath: filePath) {
            print("File exists")
        } else {
            print("File not found")
            return " "
        }
        
        // Count lines in the random file
        NSLog("Start counting lines")
        let databuffer = fm.contents(atPath: filePath)
        let data = String(data: databuffer!, encoding: .utf8)
        var myStrings = data?.components(separatedBy: .newlines)
        NSLog("Counting lines ended")
        print("nLines: " + String((myStrings!.count)))
        
        var randomIndex: Int = 0
        
        print(resultArray)
        // Repeat pick random line until line does not exist in array
        repeat {
            // Pick a random line
            randomIndex = randomNumber(n: (myStrings!.count))
            NSLog("Pick one random number for lines")
            print("Data: " + (myStrings?[randomIndex])!)
        } while resultArray.contains((myStrings?[randomIndex])!)
        
        resultArray.append((myStrings?[randomIndex])!)
        
        // Parse line to be a result
        let results = (myStrings?[randomIndex])!.components(separatedBy: ",")
        var resultString: String = ""
        for data in results {
            resultString.append(data + " \n")
        }
        print("Result: " + resultString)
        
        return String(resultString)
    }
    
    // Generate random number
    func randomNumber(n: Int) -> Int {
        let randomFileNum:UInt32 = arc4random_uniform(UInt32(n))
        let randomNum:Int = Int(randomFileNum)
        return randomNum
    }
    
    // Make timer and run randomMid func every 0.125s
    func runAuto() {
        isStarted = true
        myTimer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector:#selector(ViewController.randomMid), userInfo: nil, repeats: true)
    }
    
    // Generate random MID and change UI Label
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

    override func viewWillDisappear() {
        // Save results to file
        let joinedResult = resultArray.joined(separator: "\n")
        do{
            try (joinedResult.write(toFile: resultFile, atomically: false, encoding: .utf8))
        } catch {
            print (error)
        }
        print(resultArray)
        print("View will disappear")
    }
}


