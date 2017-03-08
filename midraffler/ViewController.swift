//
//  ViewController.swift
//  midraffler
//
//  Created by LINE on 3/7/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var isStarted: Bool=false;
    var fileName: String?;

    @IBOutlet weak var midTextField: NSTextField!
    
    
    @IBAction func onStartClick(_ sender: NSButton)
    {
        isStarted = true;
        print("Start? " + String(isStarted));
//        midTextField.stringValue = String(isStarted);
        midTextField.stringValue = randomMid();
    }
    
    @IBAction func onEndClick(_ sender: NSButton)
    {
        isStarted = false;
        print("Start? " + String(isStarted));
        midTextField.stringValue = String(isStarted);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if let fp = Bundle.main.path(forResource: "data/test", ofType: "txt")
//        {
//            do
//            {
//                let ctt=try String(contentsOfFile: fp)
//                let lines=ctt.components(separatedBy: "\n");
//                for line in lines
//                {
//                    print("line: " + line);
//                }
//            }
//            catch
//            {
//                print("cannot load content");
//            }
//        }
//        else
//        {
//            print("data/test not found");
//        }

        if CommandLine.argc > 1
        {
            fileName=CommandLine.arguments[1];
        }
        else
        {
            fileName=""
        }
        let fm = FileManager.default;
        print("PWD: " + fm.currentDirectoryPath);
        midTextField.stringValue=fileName!;
    }

    override var representedObject: Any?
    {
        didSet
        {
        // Update the view, if already loaded.
        }
    }

    override func mouseDown(with event: NSEvent)
    {
//      let pt : NSPoint=event.locationInWindow;
//      print("clicked at: " +  String(describing: pt.x) + "," + String(describing: pt.y));

//        isStarted = !isStarted;
//        print("Start? " + String(isStarted));
//        midTextField.stringValue = String(isStarted);
    }
    
    func randomMid() -> String
    {
        let seeds : String = "qwertyuiopasdfghjklzxcvbnm1234567890";
        let len = seeds.characters.count;
        
        var mid="u";
        
        for _ in 0 ..< 30
        {
            let rand = Int(arc4random_uniform(UInt32(len)));
            let idx = seeds.index(seeds.startIndex, offsetBy: rand);
            let nextChar = seeds[idx];
            mid += String(nextChar);
        }
        
        return mid;
    }

}

