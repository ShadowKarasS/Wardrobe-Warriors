//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    let e = Weathers(t:19)
    @State private var matchedTops = [ArticleOfClothing]()
    @State private var matchedBottoms = [ArticleOfClothing]()

    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingAlert = false
    @State private var selectedFormality: Formality = .casual
    @State private var state: MatchingState = .unmatched
    
    var body: some View {
        VStack {
            if state == .matched {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("Now the weather is \(e.getWeatherCode())!")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(3)
                    ForEach(1..<matchedTops.count) { index in
                        MatchedOutfitSwiftUIView(numberPicked: index, matchedTops[index], matchedBottoms[index]) // matchedTops[0], matchedBottoms[0]
                    }
                }
            }
            Spacer()
        }
        .frame(width: 0.0)
        .navigationBarTitle("Today's Picks for \(String(Int(e.getWeather())))º")
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
        
        if checkNewDay() {
            // TODO: implement weather pulling
            for articleOfClothing in articlesOfClothing {
                // set picked back to zero and save
                articleOfClothing.picked = 0
                do {
                    try articleOfClothing.managedObjectContext?.save()
                } catch {
                    print(error)
                }
                
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
                matchedTops.insert(consideredTops[i], at: Int(matchedOutfits - 1))
                consideredBottoms[i].picked = matchedOutfits
                matchedBottoms.insert(consideredBottoms[i], at: Int(matchedOutfits - 1))
                matchedOutfits += 1
                
                if matchedOutfits == 5  {
                    break
                }
            }
            
            for top in matchedTops {
                do {
                    try top.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
            
            for bottom in matchedBottoms {
                do {
                    try bottom.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
        } else {
            let sortedArticlesOfClothing = articlesOfClothing.sorted { $0.picked < $1.picked }
            for articleOfClothing in sortedArticlesOfClothing {
                if articleOfClothing.picked == 0 {
                    continue
                }
                if articleOfClothing.typeOfClothing == .shirt || articleOfClothing.typeOfClothing == .longSleeveShirt {
                    matchedTops.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                } else {
                    matchedBottoms.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                }
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
    
    func checkNewDay() -> Bool {
        let defaults = UserDefaults.standard
        let savedDate = defaults.object(forKey: "LastRun") as? Date
        let todaysDate = Date()
        if savedDate == nil {
            defaults.setValue(Date(), forKey: "LastRun")
            return true
        } else if savedDate == todaysDate {
            return true
        } else {
            defaults.setValue(Date(), forKey: "LastRun")
            return false
        }
    }

}

struct OutfitSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitSubmissionSwiftUIView()
    }
}
