//
//  ParserCharms.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//

public func >>- <T, U> (p: Parser<T>, f: T throws-> Parser<U>) -> Parser<U> {
    return p.flatMap(f)
}

public func <^> <T, U> (f: T throws-> U, p: Parser<T>) -> Parser<U> {
    return p.map(f)
}

public func <*> <T, U> (pf: Parser<T throws-> U>, p: Parser<T>) -> Parser<U> {
    return p.apply(pf)
}

public func <* <T, U> (l: Parser<T>, r: Parser<U>) -> Parser<T> {
    return {x in {_ in x}} <^> l <*> r
}

public func *> <T, U> (l: Parser<T>, r: Parser<U>) -> Parser<U> {
    return {_ in {$0}} <^> l <*> r
}

public func <|> <T> (l: Parser<T>, r: Parser<T>) -> Parser<T> {
    return Parser{
        do{
            return try l.trunk($0)
        }catch{
            return try r.trunk($0)
        }
    }
}


public enum ParserError:ErrorType{
    case AnyError
    case NotMatch
    case EOF
}

public func one(x:String) -> Parser<String>{
    return Parser{
        if $0.hasPrefix(x){
            return (x, $0.substringFromIndex(x.endIndex))
        }
        throw ParserError.AnyError
    }
}

public func fail<T>() -> Parser<T> {
    return Parser{_ in throw ParserError.AnyError}
}

public func not<T>(parser:Parser<T>) -> Parser<String> {
    return Parser{
        guard (try? parser.trunk($0)) == nil else{
            throw ParserError.NotMatch
        }
        guard !$0.isEmpty else{
            throw ParserError.EOF
        }
        return ($0.substringToIndex($0.startIndex.successor()),$0.substringFromIndex($0.startIndex.successor()))
    }
}

public func oneOf<T> (parsers:[Parser<T>]) -> Parser<T> {
    return parsers.reduce(fail(), combine: <|>)
}

public func some<T> (parser:Parser<T>) -> Parser<[T]> {
    return (parser >>- {x in {[x] + $0} <^> many(parser)})
}

public func many<T> (parser:Parser<T>) -> Parser<[T]> {
    return some(parser) <|> .unit([])
}

public func many<T, U> (parser:Parser<T>, sepBy:Parser<U>) -> Parser<[T]> {
    return {x in {x + [$0]}} <^> many(parser <* sepBy) <*> parser <|> .unit([])
}