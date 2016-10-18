//
//  main.swift
//  Test
//
//  Created by 郑宇琦 on 2016/10/18.
//  Copyright © 2016年 郑宇琦. All rights reserved.
//

import UIKit
import Foundation

ZYQLeaks.setPrintOption(printOption: .All)
ZYQLeaks.start()

autoreleasepool(invoking: {
    UIApplicationMain(0, nil, nil, NSStringFromClass(AppDelegate.self))
})
