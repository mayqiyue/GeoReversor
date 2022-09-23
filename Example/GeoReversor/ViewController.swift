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
        print("start")
        let reversor = GeoReversor()
        let result = reversor.search((30.50633, 114.35046)).first
        print("end")

        let language = Array(Locale.preferredLanguageCode.components(separatedBy: "-").dropLast(1)).joined(separator: "-")
        if let result = result {
            print("result is : \(result)")
            print("result locazlied city name is:(\(language),\(result.localizedName(language)))")
        } else {
            print("not found ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Locale {
    /// Remove region code
    /// zh-Hans-US -> zh-Hans
    static var preferredLanguageCode: String {
        let full = preferredLanguages[0]
        let array = full.components(separatedBy: "-")
        if array.count >= 2 {
            return Array(array.dropLast(0)).joined(separator: "-")
        }
        return full
    }
}
