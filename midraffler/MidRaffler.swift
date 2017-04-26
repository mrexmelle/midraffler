//
//  MidRaffler.swift
//  midraffler
//
//  Created by LINE on 3/20/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

class MidRaffler
{
    private static let FILE_PREFIX = "ltb_"
    private let fileMgr = FileManager.default
    private let baseDir : String
    private let resFile : String
    private let fileCount : Int
    private var resArray = [String]()
    
    public init?(fromBaseDir aBaseDir: String)
    {
        baseDir=aBaseDir+"/"
        resFile=baseDir+"results.txt"
        
        do
        {
            // count existing files
            fileCount = try fileMgr.contentsOfDirectory(atPath: baseDir).filter
            {
                $0.hasPrefix(MidRaffler.FILE_PREFIX)
            }.count
            print("MidRaffler::init - total files in \(baseDir): \(fileCount)")
            
            // check file exist or not
            if(fileMgr.fileExists(atPath: resFile))
            {
                // contain file's data in an array
                let resFileBuffer = fileMgr.contents(atPath: resFile)
                let resultData = String(data: resFileBuffer!, encoding: .utf8)
                resArray = (resultData?.components(separatedBy: .newlines))!
            }
        }
        catch
        {
            print("MidRaffler::init - error init: \(error)")
            return nil
        }

    }
    
    // pick random MID from Files
    public func draw() -> LineUser
    {
        var tempRes: String = "abcde"
        
        // repeat pick random line until line does not exist in array
        repeat
        {
            // randomise number
            let randomFile:Int = Randomiser.newInt(n: fileCount) + 1
            
            // determine selected file path
            let filePath:String = baseDir + MidRaffler.FILE_PREFIX + String(randomFile) + ".csv"
            
            // check file exist or not
            if fileMgr.fileExists(atPath: filePath)
            {
                print("MidRaffler::draw - \(filePath) exists")
            
                // count lines in the random file
                let databuffer = fileMgr.contents(atPath: filePath)
                let data = String(data: databuffer!, encoding: .utf8)
                var myStrings = data?.components(separatedBy: "\r\n")
                print("MidRaffler::draw - number of lines: " + String((myStrings!.count)))
            
                // pick a random line
                let randomIndex = Randomiser.newInt(n: (myStrings!.count))
                print("MidRaffler::draw - random index: " + String(randomIndex))
                tempRes = (myStrings?[randomIndex])!
                print("MidRaffler::draw - data: " + tempRes)
            }
            
            print("resArray count: \(resArray.count)")
        }
        while(resArray.contains(tempRes) && resArray.count <= 250)
        
        // only append if array count is smaller than fileCount and 250
        if(resArray.count <= 250)
        {
            print("MidRaffler::draw - adding: \(tempRes)")
            resArray.append(tempRes)
            print("MidRaffler::draw - regsitered mid: \(resArray.last)")
        }
        
        // parse line to be a result
        let results = (tempRes+",uname").components(separatedBy: ",")
//        let results = tempRes.components(separatedBy: ",")
        print("MidRaffler::draw - result - mid: " + results[0])
        print("MidRaffler::draw - result - username: " + results[1])
        return LineUser(mid: results[0], username: results[1])
    }
    
    // commit resArray by calling free
    public func free()
    {
        // save results to file
        let joinedResult = resArray.joined(separator: "\n")
        do
        {
            print("MidRaffler::free - resFile: \(resFile)")
            print("MidRaffler::free - resArray: \(resArray)")
            // nil means, no baseDir ever defined
            if(resFile != "")
            {
                try(joinedResult.write(toFile: resFile, atomically: false, encoding: .utf8))
            }
        }
        catch
        {
            print (error)
        }
    }
    
    // create dummy mid
    public func generateDummyMid() -> String
    {
        return Randomiser.newMid()
    }
}
