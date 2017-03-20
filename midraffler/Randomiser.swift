//
//  Randomiser.swift
//  midraffler
//
//  Created by LINE on 3/20/17.
//  Copyright © 2017 LINE. All rights reserved.
//

import Cocoa

class Randomiser
{
    private init() {}
    
    public static func newMid() -> String
    {
        let seeds:String = "qwertyuiopasdfghjklzxcvbnm1234567890";
        let len = seeds.characters.count;
        
        var mid="u";
        
        for _ in 0 ..< 32
        {
            let rand = Randomiser.newInt(n: len)
            let idx = seeds.index(seeds.startIndex, offsetBy: rand);
            let nextChar = seeds[idx];
            mid += String(nextChar);
        }
        
        return mid
    }
    
    public static func newInt(n: Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(n)))
    }
}
