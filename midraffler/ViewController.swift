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
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
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
        
        for _ in 0 ..< 32
        {
            let rand = Int(arc4random_uniform(UInt32(len)));
            let idx = seeds.index(seeds.startIndex, offsetBy: rand);
            let nextChar = seeds[idx];
            mid += String(nextChar);
        }
        
        return mid;
    }
    
    /*
    override func viewDidAppear() {
        while true{
            let delay = Int(1 * Double(1000))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                self.midTextField.stringValue = self.randomMid();
                print ("*")
            }
        }
    }
    */
}


