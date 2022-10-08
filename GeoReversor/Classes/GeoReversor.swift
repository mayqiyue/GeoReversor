//
//  GeoReversor.swift
//  GeoReversor
//
//  Created by float on 2022/9/20.
//

import Foundation
import SSZipArchive

public class GeoReversor: NSObject {
    public private(set) var _locationsMap: [String: GeoLocation]?
    private var _tree: KDTree<GeoLocation>?

    /// Search for closest k known locations to these coordinates
    /// point: (latitude, longitude)
    public func search(_ point: (Double, Double), k: Int = 1) -> [GeoLocation] {
        let (longitude, latitude) = point
        var locationsMap: [String: GeoLocation]! = _locationsMap
        var tree: KDTree<GeoLocation>! = _tree

        if locationsMap == nil {
            _locationsMap = extractGeoData()
            locationsMap = _locationsMap
        }
        if tree == nil {
            _tree = KDTree(values: Array(locationsMap.values))
            tree = _tree
        }
        let targets = tree.nearestK(k, to: .init(id: "", name: "", alternatenames: [""], latitude: longitude, longitude: latitude, contryCode: "", contry: ""))
        return targets
    }

    private func extractGeoData() -> [String: GeoLocation] {
        var cities: [String: GeoLocation] = [:]

        guard let cityFileURL = unzipFile(name: "cities5000", ext: "txt") else {
            return cities
        }
        guard let geoString = try? String(contentsOf: cityFileURL, encoding: .utf8) else {
            return cities
        }
        let countryMap = extractCountryData()

        for row in geoString.components(separatedBy: "\n").dropLast(1) { // drop last empty line
            let columns = row.components(separatedBy: "\t")
            let city = GeoLocation(id: columns[0], name: columns[1], alternatenames: columns[3].components(separatedBy: ","), latitude: Double(columns[4])!, longitude: Double(columns[5])!, contryCode: columns[8], contry: countryMap[columns[8]])
            cities[columns[0]] = city
        }
        return cities
    }

    private func extractCountryData() -> [String: String] {
        guard let countryFileURL = contentBundle.url(forResource: "countries", withExtension: "txt") else {
            return [:]
        }
        guard let string = try? String(contentsOf: countryFileURL, encoding: .utf8) else {
            return [:]
        }

        var map: [String: String] = [:]

        for row in string.components(separatedBy: "\n") {
            if row.isEmpty { continue }
            let columns = row.components(separatedBy: ",")
            map[columns[0]] = map[columns[1]]
        }
        return map
    }

    private func unzipFile(name: String, ext: String) -> URL? {
        guard let filePath = contentBundle.url(forResource: name, withExtension: "zip")?.path else {
            return nil
        }
        let destURL = getDocumentsDirectory().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: destURL.path) {
            try? FileManager.default.removeItem(at: destURL)
        }
        guard true == SSZipArchive.unzipFile(atPath: filePath, toDestination: destURL.path) else {
            return nil
        }
        return destURL.appendingPathComponent("\(name).\(ext)")
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private lazy var contentBundle: Bundle = {
        let mainBundle = Bundle(for: Self.self)
        if let resourceBundle = Bundle(url: mainBundle.bundleURL.appendingPathComponent("GeoReversor.bundle")) {
            return resourceBundle
        }
        return mainBundle
    }()
}
