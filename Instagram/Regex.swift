//
//  Regx.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

enum Validate {

case email(_: String)
case URL(_ :String)

     var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
            currObject = str
        case let .URL(str):
            predicateStr = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
            currObject = str
        }
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with:currObject)
    }
}
