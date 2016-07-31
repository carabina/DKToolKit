//
//  ViewController.swift
//  DKToolKit
//
//  Created by drinking on 07/31/2016.
//  Copyright (c) 2016 drinking. All rights reserved.
//

import UIKit
import DKToolKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        FilePathParser.parse("xxx")
    }

}

