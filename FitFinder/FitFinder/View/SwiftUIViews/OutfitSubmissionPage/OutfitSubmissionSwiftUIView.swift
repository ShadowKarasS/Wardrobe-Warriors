//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    let e = Weathers(t:19)
    
    var body: some View {
        NavigationView {
            VStack {     
                ScrollView(.vertical, showsIndicators: false) {
                    
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
            .navigationBarTitle("Today's Picks for \(String(format: "%.1f",e.getWeather())) º")
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
