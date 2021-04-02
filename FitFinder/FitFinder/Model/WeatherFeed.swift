//
//  WeatherFeed.swift
//  FitFinder
//
//  Created by Thunnathorne Synhiranakkrakul on 3/15/21.
//

import Foundation
import UIKit

class WeatherFeed:ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case lat
        case lon
        case temp
        case feels_like
        case wind_speed
        case humidity
        case weather_code
        case observation_time
    }
    @Published var lat:Float?
    @Published var lon:Float?
    @Published var temp:Property?
    @Published var feels_like:Property?
    @Published var wind_speed:Property?
    @Published var humidity:Property?
    @Published var weather_code:Vals?
    @Published var observation_time:Vals?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Float.self, forKey: .lat)
        lon = try container.decode(Float.self, forKey: .lon)
        temp = try container.decode(Property.self, forKey: .temp)
        feels_like = try container.decode(Property.self, forKey: .feels_like)
        wind_speed = try container.decode(Property.self, forKey: .wind_speed)
        humidity = try container.decode(Property.self, forKey: .humidity)
        weather_code = try container.decode(Vals.self, forKey: .weather_code)
        observation_time = try container.decode(Vals.self, forKey: .observation_time)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(temp, forKey: .temp)
        try container.encode(feels_like, forKey: .feels_like)
        try container.encode(wind_speed, forKey: .wind_speed)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(weather_code, forKey: .weather_code)
        try container.encode(observation_time, forKey: .observation_time)
    }
}

class Property: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case value
        case units
    }
    @Published var value:Float?
    @Published var units:String?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Float.self, forKey: .value)
        units = try container.decode(String.self, forKey: .units)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(units, forKey: .units)
    }
}
class Vals: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case value
    }
    @Published var value:String?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }
}

class Google: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case results
    }
    @Published var results:[subGoogle]?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([subGoogle].self, forKey: .results)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
    }
}

class subGoogle: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case formatted_address
    }
    @Published var formatted_address:String?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        formatted_address = try container.decode(String.self, forKey: .formatted_address)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(formatted_address, forKey: .formatted_address)
    }
}

class PreWeather: ObservableObject, Codable{
    enum CodingKeys: CodingKey {
        case results
    }
    @Published var results:[WeatherFeed]?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([WeatherFeed].self, forKey: .results)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
    }
}


