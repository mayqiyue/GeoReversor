//
//  GeoLocation.swift
//  GeoReversor
//
//  Created by float on 2022/9/20.
//

import Foundation
import NaturalLanguage

public struct GeoLocation {
    public let id: String
    public let name: String
    public let alternatenames: [String]
    public let latitude: Double
    public let longitude: Double
    public let contryCode: String
    public let contry: String?
}

extension GeoLocation {
    /// code: country code, default is device's current language code
    public func localizedName(_ code: String = Locale.preferredLanguageCode) -> String {
        let recognizer = NLLanguageRecognizer()
        for string in alternatenames {
            recognizer.processString(string)
            if let languageCode = recognizer.dominantLanguage?.rawValue, languageCode == code {
                return string
            }
        }
        return name
    }
}

extension GeoLocation: KDTreePoint {
    public static var dimensions: Int = 2

    public func kdDimension(_ dimension: Int) -> Double {
        return dimension == 0 ? Double(longitude) : Double(latitude)
    }

    public func squaredDistance(to otherPoint: GeoLocation) -> Double {
        return distance((latitude, longitude), (otherPoint.latitude, otherPoint.longitude))
    }

    private func distance(_ point1: (Double, Double), _ point2: (Double, Double)) -> Double {
        let (uLat, uLng) = point1
        let (sLat, sLng) = point2

        let radius: Double = 3959.0 // earth radius in Miles

        let deltaP = (sLat.degreesToRadians - uLat.degreesToRadians)
        let deltaL = (sLng.degreesToRadians - uLng.degreesToRadians)
        let a = sin(deltaP / 2) * sin(deltaP / 2) + cos(uLat.degreesToRadians) * cos(sLat.degreesToRadians) * sin(deltaL / 2) * sin(deltaL / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let d = radius * c

        return abs(d.roundToPlaces(2)) // distance in miles rounded to 2 decimal places
    }
}

private extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180
    }

    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Locale {
    /// Remove region code
    /// zh-Hans-US -> zh-Hans
    public static var preferredLanguageCode: String {
        let full = preferredLanguages[0]
        let array = full.components(separatedBy: "-")
        if array.count >= 2 {
            return Array(array.dropLast(1)).joined(separator: "-")
        }
        return full
    }
}
