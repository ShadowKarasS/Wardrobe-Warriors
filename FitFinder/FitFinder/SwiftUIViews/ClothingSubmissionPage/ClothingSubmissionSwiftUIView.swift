//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct ClothingSubmissionSwiftUIView: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
    var typesOfClothing = ["TShirt", "Long-Sleeved Shirt", "Pants", "Shorts", "Skirt"]
    @State private var selectedTypeOfClothing = 0
    
    @State private var formality = 0
    var typeOfFormality = ["Casual", "Formal"]
    
    @State private var celsius: Double = 0
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $formality, label: Text("Choose the Formality")) {
                    ForEach(0..<typeOfFormality.count) { index in
                        Text(self.typeOfFormality[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(32)
                
                ClothingPictureSwiftUIView()
                
                HStack {
                    Text("Cold")
                        .foregroundColor(.blue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Hot")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .padding(20)
                
                Slider(value: $celsius, in: -100...100, step: 0.1)
                
            }
            .navigationTitle("Add New Clothes")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        
                                    }
            )
        }
    }
}

struct ClothingSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingSubmissionSwiftUIView()
    }
}
