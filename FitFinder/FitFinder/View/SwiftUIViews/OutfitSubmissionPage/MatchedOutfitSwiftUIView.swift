//
//  MatchedOutfitSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 3/21/21.
//

import SwiftUI

struct MatchedOutfitSwiftUIView: View {
    private static let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
    private static let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
    private static let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
    private static let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)

    var matchedTop: ArticleOfClothing
    var matchedBottom: ArticleOfClothing
    var numberPicked = 0
    var headlineText: String {
        switch numberPicked {
        case 0:
            return "Your First Choice"
        case 1:
            return "Your Second Choice"
        case 2:
            return "Your Third Choice"
        case 3:
            return "Your Fourth Choice"
        case 4:
            return "Your Fifth Choice"
        default:
            return ""
        }
    }

    init(numberPicked: Int, _ matchedTop: ArticleOfClothing,_ matchedBottom: ArticleOfClothing) {
        self.numberPicked = numberPicked
        self.matchedTop = matchedTop
        self.matchedBottom = matchedBottom
    }
    
    var body: some View {
        HStack {
            Text("   " + headlineText)
                .font(.title)
                .foregroundColor(MatchedOutfitSwiftUIView.peachColor)
                .padding(3)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .fill(MatchedOutfitSwiftUIView.creamColor)
                )
                .offset(x: -6, y: 0)
                Spacer()
        }

        VStack {
            if let image = matchedTop.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 265.0, height: 265.0)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .shadow(radius: 5)
            }
            if let image = matchedBottom.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 265.0, height: 265.0)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .cornerRadius(25)
                    .shadow(radius: 5)
            }
            
        }
        .frame(width: 300.0, height: 560.0)
        .background(MatchedOutfitSwiftUIView.creamColor)
//        Color(.sRGB, red: Double(matchedTop.red) / 255.0, green: Double(matchedTop.green) / 255.0, blue: Double(matchedTop.blue) / 255.0, opacity: 1.0)
        .clipShape(Rectangle())
        .cornerRadius(25)
        .padding(.bottom)
        .shadow(radius: 5)
    }
}

//struct MatchedOutfitSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchedOutfitSwiftUIView(numberPicked: 1)
//    }
//}
