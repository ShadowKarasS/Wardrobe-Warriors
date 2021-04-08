//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct ClothingSubmissionSwiftUIView: View {
    
    var existingArticleOfClothing: ArticleOfClothing?
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: Type of Clothing Variables
    var typesOfClothing = [TypeOfClothing.shirt, TypeOfClothing.longSleeveShirt, TypeOfClothing.pants, TypeOfClothing.shorts, TypeOfClothing.skirt]
    @State private var selectedTypeOfClothing = 0
    
    // MARK: Formality Variables
    @State private var pickedFormality = 0
    var typeOfFormality = [Formality.casual, Formality.formal]
    
//    @State private var fahrenheit: Double = 0
    
    // MARK: Camera Variables
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @State var selectedTemperature: Int = 0

    private let appropriateTemperatures: [String] = [Temperature.veryCold.emoji, Temperature.cold.emoji, Temperature.mild.emoji, Temperature.hot.emoji, Temperature.veryHot.emoji]
    
    
    init() {
        existingArticleOfClothing = nil
    }
    
    init(articleOfClothing: ArticleOfClothing) {
        existingArticleOfClothing = articleOfClothing
    }
    
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
                    ForEach(0..<typeOfFormality.count) {
                        switch self.typeOfFormality[$0] {
                            case .casual:
                                Text("Casual").tag($0)
                            case .formal:
                                Text("Formal").tag($0)
                        }
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
                        switch typesOfClothing[$0] {
                        case .shirt:
                            Text("Shirt")
                        case .longSleeveShirt:
                            Text("Long-Sleeve Shirt")
                        case .pants:
                            Text("Pants")
                        case .shorts:
                            Text("Shorts")
                        case .skirt:
                            Text("Skirt")
                        }
                    }
                }
                .shadow(radius: 5)
//
//                HStack {
//                    Text("Cold")
//                        .foregroundColor(.blue)
//                        .font(.headline)
//
//                    Spacer()
//
//                    Text("Hot")
//                        .foregroundColor(.red)
//                        .font(.headline)
//                }
//                .padding(20)
//
//                Slider(value: $fahrenheit, in: 0...100, step: 1)
                TemperatureSegmentedPickerSwiftUIView(items: self.appropriateTemperatures, selection: self.$selectedTemperature)
                    .padding()
                Spacer()
                
            }
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            addArticleOfClothing()
            self.mode.wrappedValue.dismiss()
        })
        .onAppear { checkForExistingArticleOfClothing() }
    }
    
    
    func addArticleOfClothing() {
        if existingArticleOfClothing != nil {

            if pickedFormality == 0 {
                existingArticleOfClothing!.rawFormality = Formality.casual.rawValue
            } else {
                existingArticleOfClothing!.rawFormality = Formality.formal.rawValue
            }
            
            existingArticleOfClothing!.red = Int16(Int.random(in: 0...255))
            existingArticleOfClothing!.green = Int16(Int.random(in: 0...255))
            existingArticleOfClothing!.blue = Int16(Int.random(in: 0...255))
            
            if selectedTemperature == 0 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.veryCold.rawValue
            } else if selectedTemperature == 1 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.cold.rawValue
            } else if selectedTemperature == 2 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.mild.rawValue
            } else if selectedTemperature == 3 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.hot.rawValue
            } else {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.veryHot.rawValue
            }

            existingArticleOfClothing!.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing].rawValue
            existingArticleOfClothing!.image = selectedImage
            
            do {
                try existingArticleOfClothing!.managedObjectContext?.save()
            } catch {
                print(error)
            }
        
        } else {
            let newArticleOfClothing = ArticleOfClothing(context: viewContext)

            if pickedFormality == 0 {
                newArticleOfClothing.rawFormality = Formality.casual.rawValue
            } else {
                newArticleOfClothing.rawFormality = Formality.formal.rawValue
            }
            newArticleOfClothing.red = Int16(Int.random(in: 0...255))
            newArticleOfClothing.green = Int16(Int.random(in: 0...255))
            newArticleOfClothing.blue = Int16(Int.random(in: 0...255))
            
            if selectedTemperature == 0 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.veryCold.rawValue
            } else if selectedTemperature == 1 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.cold.rawValue
            } else if selectedTemperature == 2 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.mild.rawValue
            } else if selectedTemperature == 3 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.hot.rawValue
            } else {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.veryHot.rawValue
            }
            
            newArticleOfClothing.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing].rawValue
            newArticleOfClothing.image = selectedImage
            newArticleOfClothing.picked = 0
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func checkForExistingArticleOfClothing() {
        if existingArticleOfClothing != nil {
            if existingArticleOfClothing!.appropriateTemperature == Temperature.veryCold {
                selectedTemperature = 0
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.cold {
                selectedTemperature = 1
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.mild{
                selectedTemperature = 2
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.hot {
                selectedTemperature = 3
            } else {
                selectedTemperature = 4
            }
            selectedImage = existingArticleOfClothing!.image
            switch existingArticleOfClothing!.formality {
            case .casual:
                pickedFormality = 0
            case .formal:
                pickedFormality = 1
            }
            
            switch existingArticleOfClothing!.typeOfClothing {
            case .shirt:
                selectedTypeOfClothing = 0
            case .longSleeveShirt:
                selectedTypeOfClothing = 1
            case .pants:
                selectedTypeOfClothing = 2
            case .shorts:
                selectedTypeOfClothing = 3
            case .skirt:
                selectedTypeOfClothing = 4
            }

        }
    }
}

struct ClothingSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingSubmissionSwiftUIView()
    }
}
