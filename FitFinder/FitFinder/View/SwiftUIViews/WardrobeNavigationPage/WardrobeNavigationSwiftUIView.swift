//
//  WardrobeNavigationSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct WardrobeNavigationSwiftUIView: View {
    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    
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
                        Text("  " + TypeOfClothing.longSleeveShirt.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
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
                                                .gesture(
                                                                LongPressGesture(minimumDuration: 1)
                                                                    .onEnded { _ in
                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                                    }
                                                            )
                                        }
                                        .isDetailLink(false)

                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   " + TypeOfClothing.shirt.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
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
                                                .gesture(
                                                                LongPressGesture(minimumDuration: 1)
                                                                    .onEnded { _ in
                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                                    }
                                                            )

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   " + TypeOfClothing.pants.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
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
                                                .gesture(
                                                                LongPressGesture(minimumDuration: 1)
                                                                    .onEnded { _ in
                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                                    }
                                                            )

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   " + TypeOfClothing.shorts.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
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
                                                .gesture(
                                                                LongPressGesture(minimumDuration: 1)
                                                                    .onEnded { _ in
                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                                    }
                                                            )

                                        }
                                        .isDetailLink(false)
                                    }
                                }
                                
                            }
                        }
                        .padding(10)
                    }
                    HStack {
                        Text("   " + TypeOfClothing.skirt.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 17) {
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
                                                .gesture(
                                                                LongPressGesture(minimumDuration: 1)
                                                                    .onEnded { _ in
                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                                    }
                                                            )

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
//            .onAppear { clearMatchedOutfits() }
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
