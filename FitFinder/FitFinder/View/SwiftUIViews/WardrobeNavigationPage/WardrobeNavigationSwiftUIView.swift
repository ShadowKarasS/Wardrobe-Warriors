//
//  WardrobeNavigationSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct WardrobeNavigationSwiftUIView: View {
    let locationmanager = LocationManager()
    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    
    var body: some View {
        
        let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
        let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
        let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
        let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
        
        NavigationView {
            VStack {
                HStack {
                    Text("Wardrobe")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(creamColor)
                }
                .padding(8)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    HStack {
                        Text("   Long Sleeve Shirts")
                            .font(.title)
                            .foregroundColor(peachColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(creamColor)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.longSleeveShirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150.0, height: 150.0)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Rectangle())
                                                .cornerRadius(25)
                                                .shadow(radius: 5)
                                                .onTapGesture(count: 2) {
                                                    deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                }
                                            // Old Way
//                                                .gesture(
//                                                                LongPressGesture(minimumDuration: 1)
//                                                                    .onEnded { _ in
//                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
//                                                                    }
//                                                            )
                                        }
                                        .isDetailLink(false)

                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Shirts")
                            .font(.title)
                            .foregroundColor(peachColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(creamColor)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.shirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150.0, height: 150.0)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Rectangle())
                                                .cornerRadius(25)
                                                .shadow(radius: 5)
                                                .onTapGesture(count: 2) {
                                                    deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                }

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Pants")
                            .font(.title)
                            .foregroundColor(peachColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(creamColor)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.pants {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150.0, height: 150.0)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Rectangle())
                                                .cornerRadius(25)
                                                .shadow(radius: 5)
                                                .onTapGesture(count: 2) {
                                                    deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                }

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Shorts")
                            .font(.title)
                            .foregroundColor(peachColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(creamColor)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.shorts {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150.0, height: 150.0)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Rectangle())
                                                .cornerRadius(25)
                                                .shadow(radius: 5)
                                                .onTapGesture(count: 2) {
                                                    deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                }

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   Skirts")
                            .font(.title)
                            .foregroundColor(peachColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(creamColor)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.skirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150.0, height: 150.0)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Rectangle())
                                                .cornerRadius(25)
                                                .shadow(radius: 5)
                                                .onTapGesture(count: 2) {
                                                    deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                }

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                }
                Spacer()
            }
            .padding(.top, -30)
            .background(blueColor.ignoresSafeArea(.all))
//            .onAppear { clearMatchedOutfits() }
            .navigationBarItems(leading:
                                    NavigationLink(destination: OutfitSubmissionSwiftUIView()) {
                                        Image(systemName: "calendar").imageScale(.medium)
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
    
    func deleteArticleOfClothing(selectedArticleOfClothing: ArticleOfClothing) {
        guard let managedContext = selectedArticleOfClothing.managedObjectContext else {
            return
        }
        
        managedContext.delete(selectedArticleOfClothing)
        
        do {
            try managedContext.save()
            
        } catch {
            print("Delete failed")
        }
    }
    
//    func clearMatchedOutfits() {
//        for articleOfClothing in articlesOfClothing {
//            articleOfClothing.picked = 0
//            do {
//                try articleOfClothing.managedObjectContext?.save()
//            } catch {
//                print(error)
//            }
//        }
//    }
}

struct WardrobeNavigationSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeNavigationSwiftUIView()
    }
}
