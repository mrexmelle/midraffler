//
//  AppDelegate.swift
//  midraffler
//
//  Created by LINE on 3/7/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBAction func onOpenClicked(_ sender: NSMenuItem)
    {
        print("onOpenClicked - Start")
        
        // get the ViewController instance
        let vc=NSApplication.shared().mainWindow?.contentViewController as? ViewController
        
        let dialog=NSOpenPanel()
        dialog.title="Choose a directory"
        dialog.canChooseFiles=false
        dialog.canChooseDirectories=true
        dialog.canCreateDirectories=false
        dialog.allowsMultipleSelection=false
        
        var csvDir: String?
        if(dialog.runModal()==NSModalResponseOK)
        {
            let result=dialog.url
            if(result != nil)
            {
                csvDir=result!.path
                print("onOpenClicked - Directory chosen: " + csvDir!)
            }
            else
            {
                csvDir=""
                print("onOpenClicked - Empty directory selected")
            }
            vc!.loadBaseDir(dir: csvDir!)
        }
        else
        {
            print("onOpenClicked - User canceled")
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }
}

