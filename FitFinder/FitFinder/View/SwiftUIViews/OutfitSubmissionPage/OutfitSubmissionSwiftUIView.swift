//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    let e = Weathers(t:-99)
    @State private var matchedTops = [ArticleOfClothing]()
    @State private var matchedBottoms = [ArticleOfClothing]()

    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingAlert = false
    @State private var selectedFormality: Formality = .casual
    @State private var state: MatchingState = .unmatched
    
    var body: some View {
        let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
        let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
        let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
        let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
        
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
                    // can go out of bounds if not enough data
                    ForEach(0..<matchedTops.count) { index in
                        MatchedOutfitSwiftUIView(numberPicked: index, matchedTops[index], matchedBottoms[index]) // matchedTops[0], matchedBottoms[0]
                    }
                }
            }
            Spacer()
        }
        .frame(width: 0.0)
        .navigationBarTitle("Today's Picks for \(String(Int(e.getTemp())))º")
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
        .background(blueColor.ignoresSafeArea(.all))
    }
    
    func createOutfits() {
        var matchedOutfits: Int16 = 1
        var consideredClothes = [ArticleOfClothing]()
        var consideredTops = [ArticleOfClothing]()
        var consideredBottoms =  [ArticleOfClothing]()
        var topCount = 0
        var bottomCount = 0
        
        if 	checkNewDay() {
            for i in 0..<articlesOfClothing.count {
                // set picked back to zero and save
                articlesOfClothing[i].picked = 0
                do {
                    try articlesOfClothing[i].managedObjectContext?.save()
                } catch {
                    print(error)
                }
                
                if Int(e.getTemp()) < 32 &&
                    articlesOfClothing[i].appropriateTemperature == .veryCold {
                    consideredClothes.insert(articlesOfClothing[i], at: i)
                } else if Int(e.getTemp()) >= 32 &&
                            Int(e.getTemp()) < 50 &&
                            articlesOfClothing[i].appropriateTemperature == .cold {
                    consideredClothes.insert(articlesOfClothing[i], at: i)
                } else if Int(e.getTemp()) >= 50 &&
                            Int(e.getTemp()) < 65 &&
                            articlesOfClothing[i].appropriateTemperature == .mild {
                    consideredClothes.insert(articlesOfClothing[i], at: i)
                } else if Int(e.getTemp()) >= 65 &&
                            Int(e.getTemp()) < 85 &&
                            articlesOfClothing[i].appropriateTemperature == .hot {
                    consideredClothes.insert(articlesOfClothing[i], at: i)
                } else if Int(e.getTemp()) >= 85 &&
                            articlesOfClothing[i].appropriateTemperature == .veryHot {
                    consideredClothes.insert(articlesOfClothing[i], at: i)
                }
            }
            
            for articleOfClothing in consideredClothes {
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
            
            // Matching Colors
            for i in 0..<consideredTops.count {
                matchedTops.insert(consideredTops[i], at: Int(matchedOutfits - 1))
                matchedTops[Int(matchedOutfits - 1)].picked = matchedOutfits
                
                let matchedIndex = matchComplementaryColors(inputColor: consideredTops[i].color, consideredBottoms: consideredBottoms) // get the index for the matched bottom
                matchedBottoms.insert(consideredBottoms[matchedIndex], at: Int(matchedOutfits - 1)) // insert the matched bottom using the array
                matchedBottoms[Int(matchedOutfits - 1)].picked = matchedOutfits
                consideredBottoms.remove(at: matchedIndex) // remove no repeats
//                consideredBottoms[i].picked = matchedOutfits
//                matchedBottoms.insert(consideredBottoms[i], at: Int(matchedOutfits - 1))
                matchedOutfits += 1
                
                if matchedOutfits > 5 || consideredBottoms.isEmpty  {
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
        
        // MARK: Pseudo Code
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
    
    func matchComplementaryColors(inputColor: Colors, consideredBottoms: [ArticleOfClothing]) -> Int {
        switch inputColor {
        case .red:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .yellow:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .white {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .green:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                consideredBottoms[i].color == .gray ||
                consideredBottoms[i].color == .white {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .cyan:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .red ||
                    consideredBottoms[i].color == .gray {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .blue:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .yellow ||
                    consideredBottoms[i].color == .black {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .magenta:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .white:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .red {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
            
        case .black:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .white {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
            
        case .gray:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .white {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        }
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
