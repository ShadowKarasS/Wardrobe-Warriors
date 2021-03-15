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
    var typesOfClothing = [TypeOfClothing.shirt.rawValue, TypeOfClothing.longSleeveShirt.rawValue, TypeOfClothing.pants.rawValue, TypeOfClothing.shorts.rawValue, TypeOfClothing.skirt.rawValue]
    @State private var selectedTypeOfClothing = 0
    
    // MARK: Formality Variables
    @State private var pickedFormality = 0
    var typeOfFormality = [Formality.casual.rawValue, Formality.formal.rawValue]
    
    @State private var fahrenheit: Double = 0
    
    // MARK: Camera Variables
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
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
            existingArticleOfClothing!.appropriateTemperature = fahrenheit
            existingArticleOfClothing!.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing]
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
            newArticleOfClothing.appropriateTemperature = fahrenheit
            newArticleOfClothing.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing]
            newArticleOfClothing.image = selectedImage
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func checkForExistingArticleOfClothing() {
        if existingArticleOfClothing != nil {
            fahrenheit = existingArticleOfClothing!.appropriateTemperature
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
