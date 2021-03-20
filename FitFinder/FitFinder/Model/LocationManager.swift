//
//  LocationManager.swift
//  FitFinder
//
//  Created by Thunnathorne Synhiranakkrakul on 3/17/21.
//

import Foundation
import CoreLocation

class LocationManager:  NSObject, ObservableObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            print("pass")
            //L.text = "test"
        }
        else if status == .denied{
            print("Error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first{
            manager.stopUpdatingLocation()
            //print("\\nLocationManager Function Called\\n")
            let latitude:Float = Float((location.coordinate).latitude)
            let longitude:Float = Float(location.coordinate.longitude)
            print(latitude,longitude)
            let e = Weathers(t:0)
            print("Test 1 : ",e.temp)
            e.GetAPI(lat:latitude,lon:longitude)
            print("Test : ",e.getWeather())
        }
    }
}

class Weathers:NSObject{
    
    var temp:Float
    
    init(t:Float) {
        self.temp = t
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getWeather()-> Float{
        let o = 0
        let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
        do {
            
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            
            let s = savedString.split(separator: "\n", omittingEmptySubsequences: false)
            guard let e = Float(String(s[0])) else { return 0 }
            //print(type(of: e))
            return Float(e)
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return Float(o)
    }
     
    func GetAPI(lat:Float,lon:Float){
//        print("GetAPI")
        //Hit the API endpoint
        let urlString =  "https://api.climacell.co/v3/weather/realtime?lat=\(lat)&lon=\(lon)&unit_system=si&fields=temp&fields=feels_like&fields=humidity&fields=wind_speed&fields=weather_code&apikey=qWlMnQ8lMP3g0yTyFUBDpPORAgofvaYv"
        
        //print(urlString)

        let url = URL(string: urlString)

        guard url != nil else {
            print("Error with url = nil")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){
            (data,response,error) in
            
            //check error
            if error == nil && data != nil{

                let decoder = JSONDecoder()
                //let str = "Super long string here"
                let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
                //print(filename)
                do {
                    let weatherFeed = try decoder.decode(WeatherFeed.self, from: data!)
                    //print("\nClimacell Result:\n")
                    //print(weatherFeed.temp?.value as Any,weatherFeed.temp?.units as Any)
                    self.temp = ((weatherFeed.temp)?.value)! as Float
                    
                    let temp:String = NSString(format: "%.2f", (weatherFeed.temp?.value)!) as String+"\n"
                    let units:String  = (weatherFeed.temp?.units)! as String + "\n"
                    let feels_like:String  = NSString(format: "%.2f", (weatherFeed.feels_like?.value)!) as String + "\n" + units
                    let wind_speed:String  =  NSString(format: "%.2f",(weatherFeed.wind_speed?.value)!) as String + "\n"
                    let wsu:String = (weatherFeed.wind_speed?.units)! as String + "\n"
                    let humidity:String  = NSString(format: "%.2f",(weatherFeed.humidity?.value)!) as String
                    let hunit:String = (weatherFeed.humidity?.units)! as String + "\n"
                    let weather_code:String = (weatherFeed.weather_code?.value)! as String + "\n"
                    let observation_time = ((weatherFeed.observation_time)?.value)! as String + "\n"
                    let final:String = temp+units+feels_like+wind_speed+wsu+humidity+hunit+weather_code+observation_time
                    do{
                    try final.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch{
                        print("Error")
                        }
                    }
                catch{
                    print("Error in JSON parsing")
                    }
    
                }
            
            }
            
        //print("test ",self.allweatherFeed?.temp as Any)
        //L.text = NSString(format: "%.2f", t) as String

        //make the API calls
        dataTask.resume()

        //Google Part in order to get the name of place
        
//        //Hit the API endpoint
//        let urlString2 = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&key=AIzaSyCMMc1_YGKPE6hR4ZneChorSS1_dBDkCtM"
//
//        let url2 = URL(string: urlString2)
//
//        guard url2 != nil else {
//            return
//        }
//
//        let session2 = URLSession.shared
//
//        let dataTask2 = session2.dataTask(with: url2!){
//            (data,response,error) in
//
//            //check error
//            if error == nil && data != nil{
//
//                let decoder2 = JSONDecoder()
//                do {
//                    let google = try decoder2.decode(Google.self, from: data!)
//                    print("\nGoogle Result:\n")
//                    print(google.results?.prefix(1) as Any)
//                }
//                catch{
//                    print("Error in JSON parsing")
//                }
//
//            }
//        }
//        //make the API calls
//        dataTask2.resume()
    }
}
