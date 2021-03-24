//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    
    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingAlert = false
    @State private var selectedFormality: Formality = .casual
    @State private var state: MatchingState = .unmatched
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    if state == .matched {
                        MatchedOutfitSwiftUIView(numberPicked: 1)
                        MatchedOutfitSwiftUIView(numberPicked: 2)
                        MatchedOutfitSwiftUIView(numberPicked: 3)
                        MatchedOutfitSwiftUIView(numberPicked: 4)
                        MatchedOutfitSwiftUIView(numberPicked: 5)
                    }
                }
                Spacer()
            }
        }
        .navigationBarTitle("Today's Picks for 68º")
        .onAppear {
            showingAlert = true
        }
        .alert(isPresented: $showingAlert) { () -> Alert in
            let firstButton = Alert.Button.default(Text("Casual")) {
                selectedFormality = .casual
                createOutfits()
                state = .matched
            }
            let secondButton = Alert.Button.default(Text("Formal")) {
                selectedFormality = .formal
                createOutfits()
                state = .matched
            }
            return Alert(title: Text("What kind of outfits are you looking for?"), primaryButton: firstButton, secondaryButton: secondButton)
        }
    }
    
    func createOutfits() {
        
        var matchedOutfits: Int16 = 1
        var consideredTops = [ArticleOfClothing]()
        var consideredBottoms =  [ArticleOfClothing]()
        var topCount = 0
        var bottomCount = 0
        
        // TODO: implement weather pulling
        for articleOfClothing in articlesOfClothing {
            // check formality
            if articleOfClothing.formality == selectedFormality {
                if articleOfClothing.typeOfClothing == .shirt || articleOfClothing.typeOfClothing == .longSleeveShirt {
                    consideredTops.insert(articleOfClothing, at: topCount)
                    topCount += 1
                } else if articleOfClothing.typeOfClothing == .pants ||
                            articleOfClothing.typeOfClothing == .shorts ||
                            articleOfClothing.typeOfClothing == .skirt {
                    consideredBottoms.insert(articleOfClothing, at: bottomCount)
                    bottomCount += 1
                }
            }
        }
        
        // TODO: implement color matching
        for i in 0..<consideredTops.count {
            consideredTops[i].picked = matchedOutfits
            consideredBottoms[i].picked = matchedOutfits
            matchedOutfits += 1
            
            if matchedOutfits == 5  {
                break
            }
        }
        
        for top in consideredTops {
            do {
                try top.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        
        for bottom in consideredBottoms {
            do {
                try bottom.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        
        
        ////        matchOutfits() {
        //        if new day {
        //          temperature = getTemperature()
        //          matchedOutfits = 0
        //
        //          for clothing in clothes[] {
        //            if clothing.appropriateTemperature == temperature {
        //              consideredClothes[] = clothing
        //            }
        //          }
        //
        //          if consideredClothes[].count == 5 {
        //            for clothing in consideredClothes[] {
        //              if clothing.formality == selectedFormality {
        //                 if clothing.typeOfClothing == top {
        //                   consideredTops[] = clothing
        //                 } else {
        //                   consideredBottoms[] = clothing
        //                 }
        //              }
        //            }
        //          } else {
        //            for clothing in consideredClothes[] {
        //               if clothing.typeOfClothing == top {
        //                 consideredTops[] = clothing
        //               } else {
        //                 consideredBottoms[] = clothing
        //               }
        //            }
        //          }
        //
        //          for top in consideredTops[] {
        //            colorCaseTop = getColorCase(top.averageColor)
        //            for bottom in consideredBottoms[] {
        //              colorCaseBottom = getColorCase(bottom.averageColor)
        //              if colorCaseTop == colorCaseBottom {
        //                outfits[matchedOutfits].top = top
        //                outfits[matchedOutfits].bottom = bottom
        //                matchedOutfits++
        //              }
        //            }
        //
        //            if outfits[].top != top {
        //              unmatchedTops[] = top
        //            }
        //          }
        //          // Dealing with unmatched clothes may change with testing
        //          for top in unmatchedTops[] {
        //            outfits[matchedOutfits].top = top
        //            outfits[matchedOutfits].bottom = consideredBottoms.randomElement()
        //            matchedOutfits++
        //          }
        //
        //          return outfits[]
        //
        //        } else {
        //          return outfits[]
        //        }
        //      }
    }
    
    func matchArticlesOfClothing() {
        
    }

}

struct OutfitSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitSubmissionSwiftUIView()
    }
}
