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
    var reversor = GeoReversor(divisionLevel: .second)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start")
        reversor.loadData()
        let result = reversor.search((30.50633, 114.35046)).first
        print("end")
        
        if let result = result {
            print("result is : \(result)")
            print("result locazlied city name is:(\(Locale.preferredLanguageCode),\(result.localizedName()))")
        } else {
            print("not found ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
