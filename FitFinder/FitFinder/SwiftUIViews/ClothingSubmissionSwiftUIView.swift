//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI

struct ClothingSubmissionSwiftUIView: View {
    var typesOfClothing = ["TShirt", "Long-Sleeved Shirt", "Pants", "Shorts", "Skirt"]
    @State private var selectedTypeOfClothing = 0
    
    @State private var formality = 0
    var typeOfFormality = ["Casual", "Formal"]
    
    @State private var celsius: Double = 0
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Add New Clothes")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(8)
                .offset(y: 55)
                
                Picker(selection: $formality, label: Text("Choose the Formality")) {
                    ForEach(0..<typeOfFormality.count) { index in
                        Text(self.typeOfFormality[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
//                .offset(y: 110)
                .padding()
                .offset(y: 35)
                
                Image("tshirt")
                    .resizable()
                    .frame(width: 320.0, height: 320.0)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .shadow(radius: 5)
                    .offset(y: 35)
                
                Picker(selection: $selectedTypeOfClothing, label: Text("Please choose a type of clothing")) {
                    ForEach(0 ..< typesOfClothing.count) {
                        Text(self.typesOfClothing[$0])
                    }
                }
                .shadow(radius: 5)
                .offset(y: -45)
                .padding(12)
                
                VStack {
                    HStack {
                        Text("Cold")
                            .foregroundColor(.blue)
                            .font(.headline)
                            .shadow(radius: 5)
                        
                        Spacer()
                        
                        Text("Hot")
                            .foregroundColor(.red)
                            .font(.headline)
                            .shadow(radius: 5)
                    }
                    .padding(20)
                    
                    Slider(value: $celsius, in: -100...100, step: 0.1)
                        .padding(12)
                }
                .offset(y: -80)
            }
//            .navigationBarTitle(Text(""), displayMode: .inline)
//            .navigationBarItems(leading:
//                                    Button("Wardrobe") {
//                                        print("Outfits")
//                                    },
//                                trailing:
//                                    Button("Save") {
//                                        print("Saved")
//                                    }
//            )
            
        }
    }
}

struct ClothingSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingSubmissionSwiftUIView()
    }
}
