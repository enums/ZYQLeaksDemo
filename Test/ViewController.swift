//
//  ViewController.swift
//  Test
//
//  Created by 郑宇琦 on 2016/10/15.
//  Copyright © 2016年 郑宇琦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn() {
        ZYQLeaks.printAllCounters()
    }
}




