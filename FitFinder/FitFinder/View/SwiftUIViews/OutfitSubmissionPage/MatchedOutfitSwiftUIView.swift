//
//  MatchedOutfitSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 3/21/21.
//

import SwiftUI

struct MatchedOutfitSwiftUIView: View {
    var numberPicked = 0
    var headlineText: String {
        switch numberPicked {
        case 1:
            return "Your First Choice"
        case 2:
            return "Your Second Choice"
        case 3:
            return "Your Third Choice"
        case 4:
            return "Your Fourth Choice"
        case 5:
            return "Your Fifth Choice"
        default:
            return ""
        }
    }
    
    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    
    init(numberPicked: Int) {
        self.numberPicked = numberPicked
    }
    
    var body: some View {
        HStack {
            Text(headlineText)
                .font(.headline)
            Spacer()
        }
        .padding(4)

        VStack {
            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                if articleOfClothing.typeOfClothing == .shirt ||
                    articleOfClothing.typeOfClothing == .longSleeveShirt &&
                    articleOfClothing.picked == numberPicked {
                    if let image = articleOfClothing.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 265.0, height: 265.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                } else if articleOfClothing.typeOfClothing == .pants ||
                            articleOfClothing.typeOfClothing == .shorts ||
                            articleOfClothing.typeOfClothing == .skirt &&
                            articleOfClothing.picked == numberPicked {
                    if let image = articleOfClothing.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 265.0, height: 265.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                }
            }
            
        }
        .frame(width: 300.0, height: 560.0)
        .background(Color.yellow)
        .clipShape(Rectangle())
        .cornerRadius(25)
        .padding(4)
        .shadow(radius: 5)
    }
}

struct MatchedOutfitSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedOutfitSwiftUIView(numberPicked: 1)
    }
}
