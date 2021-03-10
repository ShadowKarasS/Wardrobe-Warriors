//
//  WardrobeNavigationSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct WardrobeNavigationSwiftUIView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Wardrobe")
                        .font(.title)
                    Spacer()
                }
                .padding(8)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    HStack {
                        Text("  Long Sleeved Shirts")
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
                            Image("longsleeve")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("longsleeve3")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("longsleeve2")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Shirts")
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
                            Image("tshirt2")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("tshirt3")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("tshirt").resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Pants")
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
                            Image("yellowpants")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("pants")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            Image("sweatpants")
                                .resizable()
                                .frame(width: 150.0, height: 150.0)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Rectangle())
                                .cornerRadius(25)
                                .shadow(radius: 5)
                        }
                        .padding(10)
                    }
                }
                Spacer()
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading:
                                    NavigationLink(destination: OutfitSubmissionSwiftUIView()) {
                                        Text("Today's Picks")
                                    }
                                    .isDetailLink(false),
                                trailing:
                                    NavigationLink(destination: ClothingSubmissionSwiftUIView()) {
                                        Image(systemName: "plus").imageScale(.medium)
                                    }
                                    .isDetailLink(false)
            )
            
        }
        
    }
}

struct WardrobeNavigationSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeNavigationSwiftUIView()
    }
}
