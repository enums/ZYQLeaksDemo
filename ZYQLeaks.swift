//
//  ZYQLeaks.swift
//  Test
//
//  Created by 郑宇琦 on 2016/10/15.
//  Copyright © 2016年 郑宇琦. All rights reserved.
//

import Foundation


enum ZYQLeaksPrintOption {
    case None
    case All
    case Filter
    case NotFilter
}

class ZYQLeaks: NSObject {
    
    enum ZYQLeaksStatus {
        case Recording
        case Stoped
    }
    
    static var shared = ZYQLeaks.init()
    
    var printOption = ZYQLeaksPrintOption.All
    var status = ZYQLeaksStatus.Stoped
    var record = Dictionary<String, Int>()
    var filter = Dictionary<String, Bool>()
    
    var locker = NSLock.init()
    
    private override init() {
        super.init()
        let objectClass: AnyClass = NSObject.classForCoder()
        //Exchange init method
        let objectInit = class_getInstanceMethod(objectClass, #selector(NSObject.init))
        let exchangeInit = class_getInstanceMethod(objectClass, #selector(NSObject.init(_:)))
        method_exchangeImplementations(objectInit, exchangeInit)
        //Exchange deinit method
        let objectDeinit = class_getInstanceMethod(objectClass, #selector(NSObject.deinit))
        let exchangeDeinit = class_getClassMethod(objectClass,#selector(NSObject.zyqleaksDeinit))
        method_exchangeImplementations(objectDeinit, exchangeDeinit)
    }
    
    static func setPrintOption(printOption: ZYQLeaksPrintOption) {
        shared.printOption = printOption
    }
    

    func objInit(cls: AnyClass) {
        guard status == .Recording else {
            return
        }
        let name = String.init(cString: class_getName(cls))
        locker.lock()
        if self.isClassExist(name: name) {
            self.record[name]! += 1
        } else {
            self.record[name] = 1
        }
        if (self.canClassPrint(name: name) == true) {
            print("obj_init   - \(name) : \(self.record[name]!)")
        }
        locker.unlock()
    }
    
    func objDeinit(cls: AnyClass) {
        guard status == .Recording else {
            return
        }
        let name = String.init(cString: class_getName(cls))
        locker.lock()
        if self.isClassExist(name: name) {
            self.record[name]! -= 1
        } else {
            self.record[name] = -1
        }
        if (self.canClassPrint(name: name) == true) {
            print("obj_deinit - \(name) : \(self.record[name]!)")
        }
        locker.unlock()
    }
    
    
    private func canClassPrint(name: String) -> Bool {
        switch printOption {
        case .None:
            return false
        case .All:
            return true
        case .Filter:
            return canClassPassFilter(name: name)
        case .NotFilter:
            return !canClassPassFilter(name: name)
        }
    }
    
    private func canClassPassFilter(name: String) -> Bool {
        return filter[name] == true
    }
    
    private func isClassExist(name: String) -> Bool {
        return record[name] != nil
    }
    
}

extension NSObject {
    convenience init(_ whatever : Int = 0) {
        self.init(0)
        ZYQLeaks.shared.objInit(cls: object_getClass(self))
    }
    
    static dynamic func zyqleaksDeinit() {
        ZYQLeaks.shared.objDeinit(cls: self.classForCoder())
    }
    
}
