//
//  ViewController.swift
//  GeoReversor
//
//  Created by mayqiyue on 09/20/2022.
//  Copyright (c) 2022 mayqiyue. All rights reserved.
//

import GeoReversor
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("xxxxxxxxxxxxxxxxxxxxxxxx start")
        let reversor = GeoReversor()
        let results = reversor.search((30.50633, 114.35046))
        print("xxxxxxxxxxxxxxxxxxxxxxxx end")
        print("xxxxxxxxxxxxxxxxxxxxxxxx result is : \(results.first.debugDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
