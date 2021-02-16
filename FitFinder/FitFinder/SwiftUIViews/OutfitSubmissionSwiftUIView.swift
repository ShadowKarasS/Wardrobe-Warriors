//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI

struct OutfitSubmissionSwiftUIView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("Today's Picks")
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding(3)
                    HStack {
                        Text("  For 68°")
                        Spacer()
                    }

                }

                
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
//            .navigationBarTitle(Text(""), displayMode: .inline)
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
