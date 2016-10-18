//
//  ZYQLeaksInterface.swift
//  Test
//
//  Created by 郑宇琦 on 2016/10/15.
//  Copyright © 2016年 郑宇琦. All rights reserved.
//

import Foundation

extension ZYQLeaks {
    static func start() {
        shared.record.removeAll()
        shared.status = .Recording
    }
    
    static func stop() {
        shared.status = .Stoped
    }
    
    static func setFilter(opt: Dictionary<String, Bool>) {
        for (key, canPass) in opt {
            shared.filter[key] = canPass
        }
    }
    
    static func setFilter(key: String, canPass: Bool) {
        shared.filter[key] = canPass
    }
    
    static func clearFilter() {
        shared.filter.removeAll()
    }
    
    static func printCounter(cls: String) {
        if let value = shared.record[cls] {
            print("\(cls) : \(value)")
        } else {
            print("\(cls) : Not Found!")
        }
    }
    
    static func printAllCounters() {
        for (key, value) in shared.record {
            print("\(key) : \(value)")
        }
    }
}
