//
//  GeoReversor.swift
//  GeoReversor
//
//  Created by float on 2022/9/20.
//

import Foundation

public class GeoReversor: NSObject {
    private var _locations: [GeoLocation]?
    private var _tree: KDTree<GeoLocation>?

    /// Search for closest k known locations to these coordinates
    /// point: (latitude, longitude)
    public func search(_ point: (Double, Double), k: Int = 1) -> [GeoLocation] {
        let (longitude, latitude) = point
        var locations: [GeoLocation]! = _locations
        var tree: KDTree<GeoLocation>! = _tree

        if locations == nil {
            _locations = extractGeoData()
            locations = _locations
        }
        if tree == nil {
            _tree = KDTree(values: locations)
            tree = _tree
        }
        let targets = tree.nearestK(k, to: .init(name: "", alternatenames: [""], latitude: longitude, longitude: latitude, contryCode: "", contry: ""))
        return targets
    }

    private func extractGeoData() -> [GeoLocation] {
        guard let geoString = bundleString("cities5000", ext: "txt") else {
            return []
        }
        let countryMap = extractCountryData()
        var cities: [GeoLocation] = []

        for row in geoString.components(separatedBy: "\n").dropLast(1) { // drop last empty line
            let columns = row.components(separatedBy: "\t")
            let city = GeoLocation(name: columns[1], alternatenames: columns[2].components(separatedBy: ","), latitude: Double(columns[4])!, longitude: Double(columns[5])!, contryCode: columns[8], contry: countryMap[columns[8]])
            cities.append(city)
        }
        return cities
    }

    private func extractCountryData() -> [String: String] {
        guard let string = bundleString("countries", ext: "txt") else {
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

    private func bundleString(_ name: String, ext: String) -> String? {
        let bundle = Bundle(for: Self.self)
        var url = bundle.url(forResource: name, withExtension: ext)
        if url == nil {
            url = bundle.bundleURL.appendingPathComponent("GeoReversor.bundle").appendingPathComponent("\(name).\(ext)")
        }
        guard let url = url else {
            return nil
        }
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        return string
    }
}
