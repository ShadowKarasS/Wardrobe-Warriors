//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct ClothingSubmissionSwiftUIView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var typesOfClothing = [TypeOfClothing.shirt.rawValue, TypeOfClothing.longSleeveShirt.rawValue, TypeOfClothing.pants.rawValue, TypeOfClothing.shorts.rawValue, TypeOfClothing.pants.rawValue]
    @State private var selectedTypeOfClothing = 0
    
    @State private var pickedFormality = 0
    var typeOfFormality = [Formality.casual.rawValue, Formality.formal.rawValue]
    
    @State private var celsius: Double = 0
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $pickedFormality, label: Text("Choose the Formality")) {
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
    
    func addArticleOfClothing() {
        let newArticleOfClothing = ArticleOfClothing(context: viewContext)
        if pickedFormality == 0 {
            newArticleOfClothing.rawFormality = Formality.casual.rawValue
        } else {
            newArticleOfClothing.rawFormality = Formality.formal.rawValue
        }


        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}

struct ClothingSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingSubmissionSwiftUIView()
    }
}
