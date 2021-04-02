//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    
    let e = Weathers(t:-99)

    //Test Date
    //let now = Date()
    //Test Date

    @State private var showGreeting = false
    @State private var selectedFrameworkIndex = 0
    var frameworks = ["ºF","ºC"]
    
    var body: some View {
        NavigationView {
            //wc is weather in ºC unit
            var wc:String = String(Int(e.getTemp()))
            //wf is weather in ºF unit
            var wf:String = String(e.convertc2f(temp:e.getTemp()))
            //var h:[String] = [wc,wf]
            
            //Test Date
            //let formatter = ISO8601DateFormatter()
    
            //let components = Calendar.current.dateComponents([.year,.month, .day,.hour,.minute], from: now)
            //let date2 = now.addingTimeInterval(3600*5)
//            let date2 = Calendar.current.date(byAdding: .hour, value: 5, to: now)
            //let datetime = formatter.string(from: date2)
            //components.month/year/day
            //Test Date
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
    
                    var u:String = String(Int(e.getTemp()))
                    Toggle(showGreeting ? "ºF":"ºC", isOn: $showGreeting)
                    
                    HStack {
                        Text("\(e.getDatetimeShort()) \(e.getGeoLoc())\nNow the weather is \(e.getWeatherCode()) ! ")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(3)
//                    if showGreeting{
//                                    Text("Hello World!")
//                                }
//                    else {
//                        Text(u)
//                    }
                    HStack {
                        Text("Your First Choice")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(4)
                    
                    VStack {
                        Image("blackShirtforYellow")
                            .resizable()
                            .frame(width: 265.0, height: 265.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .shadow(radius: 5)
                        
                        Image("yellowPantsforBlackShirt")
                            .resizable()
                            .frame(width: 265.0, height: 265.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .shadow(radius: 5)
                        
                    }
                    .frame(width: 300.0, height: 560.0)
                    .background(Color.yellow)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .padding(4)
                    .shadow(radius: 5)
                    
                    
                    HStack {
                        Text("Your Second Choice")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(4)
                    
                    VStack {
                        Image("")
                        Image("")
                        
                    }
                    
                }
                Spacer()
            }
            .frame(width: 0.0)
            .navigationBarTitle(showGreeting ? "Today's Picks for \(String(wf)) ºF" : "Today's Picks for \(String(wc)) ºC")
            
//            .navigationBarItems(trailing:
//                                    Button("Wardrobe") {
//                                        print("Outfits")
//                                    }
//            )
            
        }
    }
}

struct OutfitSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitSubmissionSwiftUIView()
    }
}
