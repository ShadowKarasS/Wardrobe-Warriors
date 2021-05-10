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
        VStack {
            if state == .matched {
                HStack {
                    Text("Today's Picks for \(String(Int(e.getTemp())))º")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(FitFinderColors.creamColor.color)
                }
                .padding(8)
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("Now the weather is \(e.getWeatherCode())!")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(FitFinderColors.creamColor.color)
                    }
                    .padding(3)
                    // can go out of bounds if not enough data
                    ForEach(0..<matchedTops.count) { index in
                        MatchedOutfitSwiftUIView(numberPicked: index, matchedTops[index], matchedBottoms[index])
                    }
                }
            }
            Spacer()
        }
        .padding(.top, -40)
        .onAppear {
            showingAlert = true
        }
        .alert(isPresented: $showingAlert) { () -> Alert in
            let firstButton = Alert.Button.default(Text("Casual")) {
                selectedFormality = .casual
                createOutfits()
            }
            let secondButton = Alert.Button.default(Text("Formal")) {
                selectedFormality = .formal
                createOutfits()
            }
            return Alert(title: Text("What kind of outfits are you looking for?"), primaryButton: firstButton, secondaryButton: secondButton)
        }
        .background(FitFinderColors.blueColor.color.ignoresSafeArea(.all))
    }
    
    func createOutfits() {
        
        if checkNewDay() {
            var matchedOutfits: Int16 = 1
            var consideredClothes = ([ArticleOfClothing](), [ArticleOfClothing]())
            var consideredTops = [ArticleOfClothing]()
            var consideredBottoms =  [ArticleOfClothing]()
            
            consideredClothes = getConsideredClothing()
            consideredTops = consideredClothes.0
            consideredBottoms = consideredClothes.1
            
            // Matching Colors
            for _ in 0..<5 {
                guard matchedTops.count < 5 && !consideredTops.isEmpty && !consideredBottoms.isEmpty else {
                    break
                }
                // grab random top
                let randomIndex = Int.random(in: 0..<consideredTops.count)
                matchedTops.insert(consideredTops[randomIndex], at: Int(matchedOutfits - 1))
                matchedTops[Int(matchedOutfits - 1)].picked = matchedOutfits
                
                let matchedIndex = matchComplementaryColors(inputColor: consideredTops[randomIndex].color, consideredBottoms: consideredBottoms) // get the index for the matched bottom
                matchedBottoms.insert(consideredBottoms[matchedIndex], at: Int(matchedOutfits - 1)) // insert the matched bottom using the array
                matchedBottoms[Int(matchedOutfits - 1)].picked = matchedOutfits
                consideredTops.remove(at: randomIndex)
                consideredBottoms.remove(at: matchedIndex) // remove, no repeats
                matchedOutfits += 1
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
            
            state = .matched
        } else {
            let sortedArticlesOfClothing = articlesOfClothing.sorted { $0.picked < $1.picked }
            for articleOfClothing in sortedArticlesOfClothing {
                if articleOfClothing.picked == 0 {
                    continue
                }
                if articleOfClothing.clothingCategory == "top" {
                    matchedTops.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                } else {
                    matchedBottoms.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                }
            }
            
            state = .matched
        }
    }
    
    func matchComplementaryColors(inputColor: Colors, consideredBottoms: [ArticleOfClothing]) -> Int {
        switch inputColor {
        case .red:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .cyan ||
                    consideredBottoms[i].color == .blue {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .yellow:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .green:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                consideredBottoms[i].color == .gray ||
                consideredBottoms[i].color == .white ||
                consideredBottoms[i].color == .magenta ||
                consideredBottoms[i].color == .blue {
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
                    consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .green {
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
                    consideredBottoms[i].color == .red ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
            
        case .black:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .black {
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
        if savedDate == nil {
            defaults.setValue(Date(), forKey: "LastRun")
            return true
        } else if !(Calendar.current.isDateInToday(savedDate!)) {
            defaults.setValue(Date(), forKey: "LastRun")
            return true
        } else {
            return false
        }
    }
    
    func getConsideredClothing() -> (top: [ArticleOfClothing], bottom: [ArticleOfClothing]) {
        var unconsideredClothing = [ArticleOfClothing]()
        var consideredTops = [ArticleOfClothing]()
        var consideredBottoms = [ArticleOfClothing]()
        let temperature = Double(e.getAnalyzeData(option: "AVGTEMP")) ?? 0
        var topCount = 0
        var bottomCount = 0
        var unconsideredCount = 0
        
        for i in 0..<articlesOfClothing.count {
            // set picked back to zero and save
            articlesOfClothing[i].picked = 0
            do {
                try articlesOfClothing[i].managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        
        for i in 0..<articlesOfClothing.count {
            // check formality then temperature then type of clothing
            if articlesOfClothing[i].formality == selectedFormality {
                if temperature < 32 &&
                    articlesOfClothing[i].appropriateTemperature == .veryCold {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        // add to considered tops, add to top count, and remove the clothing from unconsideredClothing
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: i)
                        bottomCount += 1
                    }
                } else if temperature >= 32 &&
                            temperature < 50 &&
                            articlesOfClothing[i].appropriateTemperature == .cold {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 50 &&
                            temperature < 65 &&
                            articlesOfClothing[i].appropriateTemperature == .mild {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 65 &&
                            temperature < 85 &&
                            articlesOfClothing[i].appropriateTemperature == .hot {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 85 &&
                            articlesOfClothing[i].appropriateTemperature == .veryHot {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else {
                    unconsideredClothing.insert(articlesOfClothing[i], at: unconsideredCount)
                    unconsideredCount += 1
                }
            }
        }
        
        if !unconsideredClothing.isEmpty && topCount < 3 {
            for i in 0..<unconsideredCount {
                if unconsideredClothing[i].formality == selectedFormality &&
                    unconsideredClothing[i].clothingCategory == "top" {
                    if temperature < 32 &&
                        unconsideredClothing[i].appropriateTemperature == .cold ||
                        unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 32 &&
                                temperature < 50 &&
                                unconsideredClothing[i].appropriateTemperature == .veryCold ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 50 &&
                                temperature < 65 &&
                                unconsideredClothing[i].appropriateTemperature == .cold ||
                                unconsideredClothing[i].appropriateTemperature == .hot {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                        unconsideredClothing.remove(at: i)
                    } else if temperature >= 65 &&
                                temperature < 85 &&
                                unconsideredClothing[i].appropriateTemperature == .mild ||
                                unconsideredClothing[i].appropriateTemperature == .veryHot {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 85 &&
                                unconsideredClothing[i].appropriateTemperature == .hot ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    }
                }
            }
        }
        
        if !unconsideredClothing.isEmpty && bottomCount < 3 {
            for i in 0..<unconsideredCount {
                if unconsideredClothing[i].formality == selectedFormality && unconsideredClothing[i].clothingCategory == "bottom" {
                    if temperature < 32 &&
                        unconsideredClothing[i].appropriateTemperature == .cold ||
                        unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 32 &&
                                temperature < 50 &&
                                unconsideredClothing[i].appropriateTemperature == .veryCold ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 50 &&
                                temperature < 65 &&
                                unconsideredClothing[i].appropriateTemperature == .cold ||
                                unconsideredClothing[i].appropriateTemperature == .hot {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 65 &&
                                temperature < 85 &&
                                unconsideredClothing[i].appropriateTemperature == .mild ||
                                unconsideredClothing[i].appropriateTemperature == .veryHot {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 85 &&
                                unconsideredClothing[i].appropriateTemperature == .hot ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                }
            }
        }
        
        return (consideredTops, consideredBottoms)
    }

}

struct OutfitSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitSubmissionSwiftUIView()
    }
}
