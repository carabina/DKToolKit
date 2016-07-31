//
//  DKFileManager.swift
//  ParserKit
//
//  Created by drinking on 16/7/23.
//  Copyright © 2016年 drinking. All rights reserved.
//

import Foundation


public class FilePathParser {
    
    static func replaceDirectory(path:String)->String{
        
        //to replace it with real path
        return "real/path"
    }
    
    static public func parse(path:String)->String? {
        let subPath = {$0.reduce("",combine:+)} <^> many(not(one(" ")))
        let header =  one("file://")*>(replaceDirectory <^> (oneOf([one("doc"),one("tmp"),one("lib")])) <|> subPath)
        let parser =  ({x in {y in (x+y)}} <^> header <*> subPath)
        if case let .Success(path) = parser.parse(path){
            return path
        }
        return nil
    }
    
    
}

