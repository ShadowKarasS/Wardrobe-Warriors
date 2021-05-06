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
            print("DENIED")
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
            
            let e = Weathers(t:-99)
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
         print("Unable to Load the file")
        }
        return result
    }
    
    func checkRainChance(humid:Float) -> Bool {
        if humid > 80{
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
    func convertf2c(temp:Float) -> Int{
        return (Int((temp-32)*5/9))
    }
    
    func getAnalyzeResult()-> String{
        var result:String = ""
        let filename = self.getDocumentsDirectory().appendingPathComponent("analysisinfo.txt")
        do {
         // Get the saved data
         let savedData = try Data(contentsOf: filename)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            result = savedString
            return result
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return result
    }
    func getAnalyzeData(option:String)->String{
        if option != ""{
            let source:String = self.getAnalyzeResult()
            let field = source.split(separator: "\n")
            if option == "AVGTEMP"{
                //return average temperature
                let ans = field[0].split(separator:":")
                return String(ans[1])
            }
            else if option == "MAXTEMP"{
                //return maximum temperature
                let ans = field[1].split(separator:":")
                return String(ans[1])
            }
            else if option == "MAXTEMPTIME"{
                //return number of hours from now that going to be maximum temperature
                let ans = field[1].split(separator:":")
                return String(ans[2])
            }
            else if option == "MINTEMP"{
                //return minimum temperature
                let ans = field[2].split(separator:":")
                return String(ans[1])
            }
            else if option == "MINTEMPTIME"{
                //return number of hours from now that going to be minimum temperature
                let ans = field[2].split(separator:":")
                return String(ans[2])
            }
            else if option == "AVGHUMID"{
                //return the Average Humidity
                let ans = field[3].split(separator:":")
                return String(ans[1])
            }
            else if option == "RAINORNOT"{
                //return true / false, compare average humidity > 80%
                let ans = field[4].split(separator:":")
                return String(ans[1])
            }
            else if option == "NUMWCODE"{
                //NUMWCODE = Total Number of weather code
                let ans = field[5].split(separator:":")
                return String(ans[1])
            }
            else if option == "WCODE"{
                //WCODE = All Weather Code with colon for seperate each code
                let index:Int = 6
                let final = field[5].split(separator:":")
                var result = ""
                for n in index...(Int(final[1])! + index - 1){
                    let code = field[n].split(separator:":")
                    result = result + code[0] + ":"
                }
                return String(result)
            }
            else if option == "WCODEFBYHR"{
                //WCODEF = Weater code frequency by number of hours on each
                let index:Int = 6
                let final = field[5].split(separator:":")
                var result = ""
                for n in index...(Int(final[1])!+index-1){
                    let code = field[n].split(separator:":")
                    result = result + code[1] + ":"
                }
                return String(result)
            }
            else if option == "WCODEFBYPERCENT"{
                //WCODEF = Weater code frequency by percentage on each
                let index:Int = 6
                let final = field[5].split(separator:":")
                var result = ""
                for n in index...(Int(final[1])!+index-1){
                    let code = field[n].split(separator:":")
                    result = result + code[2] + ":"
                }
                return String(result)
            }
            else if option == "TOTALPREDICTHR"{
                //TOTALPREDICTHR = TOTAL PREDICT HOURS
                let ans = field[6+Int(self.getAnalyzeData(option: "NUMWCODE"))!].split(separator: ":")
                return String(ans[1])
            }
        }
        return "Error : Invalid Parameter"
    }
    func getStartTimeID() -> Int{
        let formatter2 = DateFormatter()
        //formatter2.dateStyle = .long
        formatter2.timeStyle = .short
        formatter2.timeZone = .current
        //formatter2.timeZone = TimeZone(abbreviation: "AKDT")
        let now = Date()
        //let i = now.description(with: .current)
        //print(now.description(with: .current))
        let datetime = formatter2.string(from: now)
        print("Now => ",datetime)
        let sep = datetime.split(separator: ":")
        let hr:Int = Int(sep[0])!
        //print(sep[0])
        if datetime.suffix(2) == "PM"{
            //print(datetime.prefix(5))
            if hr < 8{
                print(8-hr+1-1,"hours Left before 8 PM")
                return 8-hr+1+24 //stable
            }
            else if hr == 12{
                print("MidDay")
                return 9+24
            }
            else
            {
                //print(12-hr+8+1)
                print("Predict All Day Tomorrow (After 8 PM)")
                return 12-hr+8+1 //stable
            }
        }
        else if datetime.suffix(2) == "AM"{
            if hr < 8{
                //print(9-hr)
                print("Before 8 AM")
                return (9-hr) //stable
            }
            else if hr == 12{
                print("MidNight")
                return 9 //stable
            }
            else
            {
                //print(4-hr-8)
                print("After 8 AM")
                return 12-hr+9+24//unstable test-pass(simulate)
            }
        }
        else{
            print("Invalid Time")
            return -1
        }
        //return -1
    }
    func PredictWeather(hours:Double){
        
        let now = Date()
        
        let formatter = ISO8601DateFormatter()
        let date2 = now.addingTimeInterval(3600*hours)
        let datetime2 = formatter.string(from: date2)
        //let datetime = formatter.string(from: now)
        
        var time_id:Int = self.getStartTimeID()
        if(time_id<0){
            print("Error with Forecast in the duration")
        }
        //print("Start hours at ID: ",time_id)
        var time8amto8pm_statement:String = ""
        
        // t > 8pm and t < 8pm are compatible
        var where_statement:String = " id >= \(time_id) and id <= \(time_id+12-1)"
        if time_id > 24{
            time_id = time_id - 24
            where_statement = " id >= 1 and id <= \(time_id-1)"
        }
        
        time8amto8pm_statement = "SELECT *From weather where \(where_statement)"
        
        let loc:String = getLoc()
        let s = loc.split(separator: "|", omittingEmptySubsequences: false)
    
        let urlString = "https://api.climacell.co/v3/weather/forecast/hourly?lat=\(s[0])&lon=\(s[1])&unit_system=us&start_time=now&end_time=\(datetime2)&fields=temp&fields=feels_like&fields=wind_speed&fields=humidity&fields=weather_code&apikey=qWlMnQ8lMP3g0yTyFUBDpPORAgofvaYv"
        
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
                
                let decoder3 = JSONDecoder()
                do{
                    let filename = self.getDocumentsDirectory().appendingPathComponent("analysisinfo.txt")
                    var saveResult:String = ""
                    let preweather = try decoder3.decode([WeatherFeed].self, from: data!)
                    let s:[WeatherFeed] = preweather //Hold info of each hours in each Array
                    
                    //Setup/Connect to DB Weather
                    let dbw:DBweather = DBweather()
                    var dbweathers:[Weather] = []
                    //DB Weather
                    
                    //Reset DB
                    dbweathers = dbw.readman(Statement: "DELETE FROM weather WHERE 1")
                    //Reset DB
                    
                    var counter:Int = 0 //counter for hours
                    //var acttemp:Float = 0 //actually temperature
                    
                    
                    print("\nPredict Weather (\(self.getGeoLoc()) ) from 8 AM to 8 PM From Now")
                    
                    for x in s {
                        
                        //DB Insert
                        //print("Insert ",(x.temp?.value)!)
                        dbw.insert(id:(counter+1),temp:Float((x.temp?.value)!),feels:Float((x.feels_like?.value)!),humid:Float((x.humidity?.value)!), wind:Float((x.wind_speed?.value)!),code:((x.weather_code?.value)!), time:(x.observation_time?.value)!)
                        //DB Insert
                        
                            
                        counter = counter + 1
                    }
                    
                    //Fetch all result
                    //dbweathers = dbw.readall()
                    //for o in dbweathers{
                        //print(o.code,o.time)
                    //}
                    
                    //Note: All Temp value based on Feels like
                    
                    //Get Avg temp
                    let AverageTemp:Float = dbw.queryfloat(queryStatementString: "SELECT AVG(feels) from weather where \(where_statement)")
                    //print("Average Temp = ",AverageTemp)
                    saveResult = saveResult+"AVG-TEMP:"+String(format: "%.2f",AverageTemp) + "\n"
                    
                    //Get Max Temp
                    dbweathers = dbw.readman(Statement: "SELECT *From weather where feels = (Select MAX(feels) From weather where \(where_statement)) and \(where_statement)")
                    for y in dbweathers{
                        //print("MAX Temp = ",y.feels," at ",y.time," in next \(y.id-1) hour")
                        saveResult = saveResult+"MAX-TEMP:"+String(y.feels) + ":\(y.id-1)" + "\n"
                    }
                    
                    
                    //get min temp
                    dbweathers = dbw.readman(Statement:"SELECT * FROM weather where feels = (Select MIN(feels) From weather where \(where_statement)) and \(where_statement)")
                    
                    for y in dbweathers{
                        //print("MIN Temp = ",y.feels," at ",y.time," in next \(y.id-1) hour")
                        saveResult = saveResult + "MIN-TEMP:" + String(y.feels) + ":\(y.id-1)" + "\n"
                    }
                    
                    let AverageHumid:Float = dbw.queryfloat(queryStatementString: "SELECT AVG(humid) from weather where \(where_statement)")
                    //print("Average Humid = ",AverageHumid)
                    saveResult = saveResult+"AVG-HUMID:"+String(format: "%.2f",AverageHumid) + "\n"
                    
                    saveResult = saveResult + "RAIN:" + String(self.checkRainChance(humid:AverageHumid))+"\n"
                    
                    
                    //Check duration and Find total hours left in duration
                    dbweathers = dbw.readman(Statement:time8amto8pm_statement)
                    var c:Int = 0
                    for y in dbweathers{
                        //print(y.time)
                        let _ = y
                        c+=1
                    }
                    //print(c) // check total distinct weather code
                    //Check duration and Find total hours left in duration
                    
                    //find popular weather code with result as percentage
                    //print("\nOverall Weather: ")
                    var qcount:[Qcount] = []
                    
                    qcount = dbw.querycount(queryStatementString:"select count(id), code from weather where \(where_statement) group by code order by count(code) DESC")
                    
                    saveResult = saveResult + "Weather-Categories:" + String(qcount.count) + "\n"
                    for i in qcount{
                        let percent:Float = (Float(i.count*100)/Float(c))
                        let printpercent:String = String(format: "%.3f", percent)
                        //print(i.result,printpercent,"%")
                        saveResult = saveResult + i.result + ":" + String(i.count) + ":" + printpercent + "\n"
                    }
                    saveResult = saveResult + "Total Hrs between 8 AM to 8 PM From Now:" + String(c) + "\n"
                    //find popular weather code with result as percentage
                    
                    //Example of content in saved file
//                    print("\n\nSummary:Saved Analysis Data (\(String(c)) hrs) until 8 PM of the day ")
//                    print(saveResult)
                    //Example of content in saved file
                    
                    //Save all result in .txt
                    do{
                    try saveResult.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch{
                        print("Error")
                        }
//                        }
//                    }
                    //Save all result in .txt
                    
                    //Example command to get value anywhere
                    print("\nExamples command to get value Anywhere:BELOW (INLINE 444+)")
                    print("\nAverage Temperature is ",self.getAnalyzeData(option: "AVGTEMP"))
                    print("Maximum Temperature is ",self.getAnalyzeData(option: "MAXTEMP")," in ",self.getAnalyzeData(option: "MAXTEMPTIME"),"hrs")
                    print("Minimum Temperature is ",self.getAnalyzeData(option: "MINTEMP")," in ",self.getAnalyzeData(option: "MINTEMPTIME"),"hrs")
                    print("Average Humidity is ",self.getAnalyzeData(option: "AVGHUMID"))
                    print("Is it going to be Rain? ",self.getAnalyzeData(option: "RAINORNOT"))
                    print("There are ",self.getAnalyzeData(option: "NUMWCODE")," categories of weather during the duration")
                    print("Here is All weather code :",self.getAnalyzeData(option: "WCODE").split(separator: ":"))
                    print("Here is the All-weather code by total hours on each code ( it's statistic, not continuous): ",self.getAnalyzeData(option: "WCODEFBYHR").split(separator: ":"))
                    print("Here is All weather code by percentage :",self.getAnalyzeData(option: "WCODEFBYPERCENT").split(separator: ":"))
                    print("The total number of predict's hours is",self.getAnalyzeData(option: "TOTALPREDICTHR"))
                    //Example command to get value anywhere

                }
                catch{
                    print("Error in JSON parsing")
                    }
    
                }
            
            }

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
            
            if s.count > 1{
            //print("\n\n\tCheck\n",s,"\n\n\n\n")
            let actemp:Float = self.compareTemp(tem: Float(s[2])!, feels: Float(s[4])!)
            //guard let e = Float(String(s[2])) else { return Float(o) }
            //print(type(of: e))
            //print(Float(actemp).rounded())
                
            //return Float(actemp).rounded()
            //open comment above in case of bugs
            return (Float(self.getAnalyzeData(option: "AVGTEMP"))?.rounded())!
            }
            print("Check your privacy")
            return -99
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
        return Float(o)
    }
     
    func GetAPInow(lat:Float,lon:Float){
        //Hit the API endpoint
        let urlString =  "https://api.climacell.co/v3/weather/realtime?lat=\(lat)&lon=\(lon)&unit_system=us&fields=temp&fields=feels_like&fields=humidity&fields=wind_speed&fields=weather_code&apikey=qWlMnQ8lMP3g0yTyFUBDpPORAgofvaYv"
        
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
                        self.PredictWeather(hours: 24)
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
            

        //make the API calls
        dataTask.resume()

        //Google Part in order to get the name of place
        
//        //Hit the API endpoint
        let urlString2 = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&key=AIzaSyCi2BCk8iDhH4Ot8Plzxyy-D1rIFxc6q7A"
        
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
                    let result:String = String((s?[0].formatted_address)!)
                    //let result:String = s?[0].formatted_address                  //let e = Array(arrayLiteral: s)
                    //print(String((s?[0].formatted_address)!))
                    //print(s?[0].formatted_address as Any)
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
