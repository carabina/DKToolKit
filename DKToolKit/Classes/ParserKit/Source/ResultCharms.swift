//
//  ResultCharms.swift
//  SwiftCharms
//
//  Created by Ruoyu Fu on 15/2/2016.
//  Copyright © 2016 Ruoyu Fu. All rights reserved.
//


public func unit<T> (x:T) -> Result<T> {
    return .Success(x)
}

public func >>- <T, U> (r:Result<T>, f:T throws-> Result<U>) -> Result<U> {
    return r.flatMap(f)
}

public func <^> <T, U> (f: T throws-> U, r: Result<T>) -> Result<U> {
    return r.map(f)
}

public func <*> <T, U> (rf: Result<T throws-> U>, r:Result<T>) -> Result<U> {
    return r.apply(rf)
}

public extension Result {
    var value:T? {
        if case .Success(let v) = self {
            return v
        }
        return nil
    }
}