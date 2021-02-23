//
//  ClothingPictureSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/22/21.
//

import SwiftUI

struct ClothingPictureSwiftUIView: View {
    var typesOfClothing = ["TShirt", "Long-Sleeved Shirt", "Pants", "Shorts", "Skirt"]
    @State private var selectedTypeOfClothing = 0
    
    var body: some View {
        VStack {
            Image("tshirt")
                .resizable()
                .frame(width: 240.0, height: 240.0)
                .aspectRatio(contentMode: .fit)
                .clipShape(Rectangle())
                .cornerRadius(25)
                .shadow(radius: 5)
            
            Picker(selection: $selectedTypeOfClothing, label: Text("Please choose a type of clothing")) {
                ForEach(0 ..< typesOfClothing.count) {
                    Text(self.typesOfClothing[$0])
                }
            }
            .shadow(radius: 5)
        }
    }
}

struct ClothingPictureSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingPictureSwiftUIView()
    }
}
