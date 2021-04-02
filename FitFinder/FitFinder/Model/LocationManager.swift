//
//  LocationManager.swift
//  FitFinder
//
//  Created by Thunnathorne Synhiranakkrakul on 3/17/21.
//

import SwiftUI
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
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            //print("User Allowed the privacy")
        }
        else if status == .denied{
            let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
            let reset:String = ""
            do{
            try reset.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            }
            catch{
                print("Error")
                }
            print("Error with privacy")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first{
            manager.stopUpdatingLocation()
            
            //Dynamic Location depends on user
            let latitude:Float = Float((location.coordinate).latitude)
            let longitude:Float = Float(location.coordinate.longitude)
            
            //Fix lat long Bangkok
            //let latitude:Float = 14.0395
            //let longitude:Float = 100.6154
            
            //Fix position somewhere in Columbia
            //let latitude:Float = 38.9513749744266
            //let longitude:Float = -92.32723958463691
            
            //print("Your Postion is :",latitude,longitude)
            
            let e = Weathers(t:0)
            e.GetAPInow(lat:latitude,lon:longitude)
            //e.PredictWeather(hours:24)
        }
    }
}

class Weathers:NSObject{
    
    var temp:Float
    
    init(t:Float) {
        self.temp = t
    }
    
    func getDatetimenow() -> Date {
        let now = Date()
        return now
    }
    
    func getDatetimeShort() -> String {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .long
        formatter2.timeStyle = .short
        let i = getDatetimenow()
        let datetime = formatter2.string(from: i)
        //print(datetime)
        return datetime
    }
    
    func getLoc() -> String{
        var result:String = "N/A"
        let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
        do {
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            
            let s = savedString.split(separator: "\n", omittingEmptySubsequences: false)
            result = String(s[0])+"|"+String(s[1])
            return result
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return result
    }
    
    func checkRainChance(humid:Float) -> Bool {
        if humid > 90{
            return true
        }
        return false
    }
    func compareTemp(tem:Float,feels:Float)->Float{
        if tem != feels{
            return feels
        }
        return tem
    }
    func convertc2f(temp:Float) -> Int{
        return (Int((temp)*9/5)+32)
    }
    func convertHours(H:Int)->String{
        if H == 0{
            return "Now"
        }
        return String(H)
    }
    func PredictWeather(hours:Double){
        //let hours:Double = 5
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let date2 = now.addingTimeInterval(3600*hours)
        let datetime2 = formatter.string(from: date2)
        let datetime = formatter.string(from: now)
        
        let loc:String = getLoc()
        let s = loc.split(separator: "|", omittingEmptySubsequences: false)
    
        let urlString = "https://api.climacell.co/v3/weather/forecast/hourly?lat=\(s[0])&lon=\(s[1])&unit_system=si&start_time=now&end_time=\(datetime2)&fields=temp&fields=feels_like&fields=wind_speed&fields=humidity&fields=weather_code&apikey=qWlMnQ8lMP3g0yTyFUBDpPORAgofvaYv"
        
        //print(urlString)
        
//        let urlString = "https://data.climacell.co/v4/timelines?location=\(s[0]),\(s[1]),&fields=temperature&fields=humidity&fields=weatherCode&timesteps=1h&units=metric&apikey=uLQZKKLVo0TYOdqLo9X05SzeAreR6KaA"
//
//        print(urlString)
        
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
                
                let decoder3 = JSONDecoder()
                do{
                    let preweather = try decoder3.decode([WeatherFeed].self, from: data!)
                    let s:[WeatherFeed] = preweather //Hold info of each hours in each Array
                    
                    var counter:Int = 0 //counter for hours
                    var acttemp:Float = 0 //actually temperature
                    
                    var tempMax:Float = -999 //Hold Max temperature
                    var thMax:String = "-" //Hold Time of Max Temp (UTC) with ISO format
                    var tcounth:Int = 0 //hold number of hour from now that is Max Temperature
                    
                    var tempMin:Float = 1000 //Hold Min Temperature
                    var thMin:String = "-" //Hold Time of Min Temp (UTC) with ISO format
                    var tcountl:Int = 0
                    var avg_temp:Float = 0
                    
                    var humMax:Float = -99
                    var hhumMax:String = "-"
                    var hcount:Int = 0
                    var avg_humid:Float = 0
                    
                    print("\nPredict Weather in ",hours," Hours Including Now")
                    
                    for x in s {
                        
                        //print(x.weather_code?.value)
                        //compare feels and temp
                        acttemp = self.compareTemp(tem:(x.temp?.value)!, feels:(x.feels_like?.value)!)
                            
                        avg_temp = avg_temp + acttemp
                        avg_humid = avg_humid + (x.humidity?.value)!
                        
                        //Find Max Temp
                        if tempMax < acttemp{
                            tempMax = acttemp
                            thMax = (x.observation_time?.value)!
                            tcounth = counter
                        }
                        
                        //Find Min Temp
                        if tempMin > acttemp{
                            tempMin = acttemp
                            thMin = (x.observation_time?.value)!
                            tcountl = counter
                        }
                        
                        //Find Max Humidity
                        if humMax < (x.humidity?.value)! {
                            humMax = (x.humidity?.value)!
                            hhumMax = (x.observation_time?.value)!
                            hcount = counter
                        }
                        counter = counter + 1
                        //print(x.temp?.value)
                    }
                    avg_temp = avg_temp/Float(counter)
                    avg_humid = avg_humid/Float(counter)
                    print("\nTemperature Max = ",tempMax.rounded()," ",thMax," in next ",tcounth," Hours ")
                    print("Avg Temp = ",avg_temp.rounded())
                    
                    let t:String = String(tempMax.rounded()) + "|"+self.convertHours(H:tcounth)+"|"+String(format:"%.1f",tempMin)+"|"+String(self.convertHours(H: tcountl))+"|"+String(avg_temp.rounded())
                    
                    print("\nHumMax = ",humMax.rounded()," ",hhumMax," in next ",hcount," Hours ")
                    print("Avg Humid = ",avg_humid.rounded())
                    let hu:String = String(humMax.rounded())+"|"+self.convertHours(H:hcount)+"|"+String(avg_humid.rounded())
                    
                    let temTitle:String = "<TEMP> Max|Time|Min|Time|Avg\n"
                    let humTitle:String = "<HUMID> Max|Time|Avg\n"
                    let summary:String = temTitle+t+"\n"+humTitle+hu
                    
                    print("\n Date Store:\n",summary,"\n")
                    
                    if self.checkRainChance(humid:humMax) == true{
                        print("High risk to become raining")
                    }
                    else{
                        print("Low risk to become raining")
                    }
                    //print(s[0].temp?.value)
                    //print(weatherFeed.temp?.value as Any,weatherFeed.temp?.units as Any)

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
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getWeatherCode() -> String{
        let df = "N/A \n with location service is not allowed"
        let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
        do {
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            
            let s = savedString.split(separator: "\n", omittingEmptySubsequences: false)
            //print(s.count)
            if s.count > 1{
                return String(s[9])
            }
            return df
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return df
    }
    
    func getGeoLoc() ->String{
        var result:String = ""
        let filename = self.getDocumentsDirectory().appendingPathComponent("geolocation.txt")
        do {
            
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            
            let s = savedString.split(separator: ",", omittingEmptySubsequences: false)
            result = String(s[1])
            //print(type(of: e))
            return result
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return result
    }
    
    func getTemp()-> Float{
        let o:Float = -99
        let filename = self.getDocumentsDirectory().appendingPathComponent("weatherinfo.txt")
        do {
            
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            
            let s = savedString.split(separator: "\n", omittingEmptySubsequences: false)
            print("\n\n\tCheck\n",s,"\n\n\n\n")
            let actemp:Float = self.compareTemp(tem: Float(s[2])!, feels: Float(s[4])!)
            guard let e = Float(String(s[2])) else { return Float(o) }
            //print(type(of: e))
            return Float(actemp).rounded()
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return Float(o)
    }
     
    func GetAPInow(lat:Float,lon:Float){
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
                    let final:String = String(lat)+"\n"+String(lon)+"\n"+temp+units+feels_like+wind_speed+wsu+humidity+hunit+weather_code+observation_time
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
        let urlString2 = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&key=AIzaSyCMMc1_YGKPE6hR4ZneChorSS1_dBDkCtM"
        
        //print(urlString2)

        let url2 = URL(string: urlString2)

        guard url2 != nil else {
            return
        }

        let session2 = URLSession.shared

        let dataTask2 = session2.dataTask(with: url2!){
            (data,response,error) in

            //check error
            if error == nil && data != nil{

                let decoder2 = JSONDecoder()
                let filename = self.getDocumentsDirectory().appendingPathComponent("geolocation.txt")
                do {
                    let google = try decoder2.decode(Google.self, from: data!)
                    //print("\nGoogle Result:\n")
                    let s = google.results?.prefix(1)
                    let result:String = (s?[0] .formatted_address)!
                    //let e = Array(arrayLiteral: s)
                    //print(s?[0] .formatted_address)
                    do{
                    try result.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch{
                        print("Error save the geolocation")
                        }
                    //print(google)

                }
                catch{
                    print("Error in JSON parsing")
                }

            }
        }
        //make the API calls
        dataTask2.resume()
    }
}

extension Weathers {
    
    enum Icon: String, Codable {
        
        case clearDay = "clear-day"
        case clearNight = "clear-night"
        case rain = "rain"
        case snow = "snow"
        case sleet = "sleet"
        case wind = "wind"
        case fog = "fog"
        case cloudy = "cloudy"
        case partyCloudyDay = "partly-cloudy-day"
        case partyCloudyNight = "partly-cloudy-night"
        
        var image: Image {
            switch self {
            case .clearDay:
                return Image(systemName: "sun.max.fill")
            case .clearNight:
                return Image(systemName: "moon.stars.fill")
            case .rain:
                return Image(systemName: "cloud.rain.fill")
            case .snow:
                return Image(systemName: "snow")
            case .sleet:
                return Image(systemName: "cloud.sleet.fill")
            case .wind:
                return Image(systemName: "wind")
            case .fog:
                return Image(systemName: "cloud.fog.fill")
            case .cloudy:
                return Image(systemName: "cloud.fill")
            case .partyCloudyDay:
                return Image(systemName: "cloud.sun.fill")
            case .partyCloudyNight:
                return Image(systemName: "cloud.moon.fill")
            }
        }
                
    }
    
}


