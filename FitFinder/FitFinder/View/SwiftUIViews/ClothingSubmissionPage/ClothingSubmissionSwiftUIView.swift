//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct ClothingSubmissionSwiftUIView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: Type of Clothing Variables
    var typesOfClothing = [TypeOfClothing.shirt.rawValue, TypeOfClothing.longSleeveShirt.rawValue, TypeOfClothing.pants.rawValue, TypeOfClothing.shorts.rawValue, TypeOfClothing.pants.rawValue]
    @State private var selectedTypeOfClothing = 0
    
    // MARK: Formality Variables
    @State private var pickedFormality = 0
    var typeOfFormality = [Formality.casual.rawValue, Formality.formal.rawValue]
    
    @State private var fahrenheit: Double = 0
    
    // MARK: Camera Variables
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("      Add New Clothes")
                        .fontWeight(.bold)
                        .font(.title)
                    Spacer()
                }
                Picker(selection: $pickedFormality, label: Text("Choose the Formality")) {
                    ForEach(0..<typeOfFormality.count) { index in
                        Text(self.typeOfFormality[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(32)
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 240.0, height: 240.0)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                        .cornerRadius(25)
                        .shadow(radius: 5)
                } else {
                    Image("tshirt")
                        .resizable()
                        .frame(width: 240.0, height: 240.0)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                HStack {
                    Button("                    Camera") {
                        self.sourceType = .camera
                        self.isImagePickerDisplay.toggle()
                    }
                    Spacer()
                    Button("Photo Library               ") {
                        self.sourceType = .photoLibrary
                        self.isImagePickerDisplay.toggle()
                    }
                }
                Picker(selection: $selectedTypeOfClothing, label: Text("Please choose a type of clothing")) {
                    ForEach(0 ..< typesOfClothing.count) {
                        Text(self.typesOfClothing[$0])
                    }
                }
                .shadow(radius: 5)
                
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
                
                Slider(value: $fahrenheit, in: 0...100, step: 1)
                
            }
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            addArticleOfClothing()
            self.mode.wrappedValue.dismiss()
        })
    }
    
    
    func addArticleOfClothing() {
//        newItem = NSEntityDescription.insertNewObject(forEntityName: "Feature", into: context) as! SSFeatureMO
        let newArticleOfClothing = ArticleOfClothing(context: viewContext)
//        let newArticleOfClothing = NSEntityDescription.insertNewObject(forEntityName: "ArticleOfClothing", into: viewContext) as! ArticleOfClothing
        if pickedFormality == 0 {
            newArticleOfClothing.rawFormality = Formality.casual.rawValue
        } else {
            newArticleOfClothing.rawFormality = Formality.formal.rawValue
        }
        newArticleOfClothing.red = Int16(Int.random(in: 0...255))
        newArticleOfClothing.green = Int16(Int.random(in: 0...255))
        newArticleOfClothing.blue = Int16(Int.random(in: 0...255))
        newArticleOfClothing.appropriateTemperature = fahrenheit
        newArticleOfClothing.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing]
        newArticleOfClothing.image = selectedImage ?? nil
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
