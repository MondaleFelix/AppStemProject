//
//  SuggestionManager.swift
//  AppStemProject
//
//  Created by Mondale on 4/26/22.
//

import UIKit

class SuggestionManager {
    
    static let shared = SuggestionManager()
    var dictionary: [String] = []
    var histogram: [String] = []
    private init() {
        getDictionaryWords()
    }
        
    
    // Retreives words from txt file
    func getDictionaryWords(){
        if let path = Bundle.main.path(forResource: "dictionary", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let words = data.components(separatedBy: .newlines)
                
                
                let parsedWords = words.map { (string) -> String in
                    string.replacingOccurrences(of: "\\", with: "")
                }
                
                DispatchQueue.main.async {
                    self.dictionary.append(contentsOf: parsedWords)
                }

            } catch {
                print(error)
            }
        }
    }
    
    
    // Returns the frequency of characters in order
    func createHistogram(word:String) -> Histogram {
        
        var histCounts: [HistCounts] = []
        for (index, letter) in word.enumerated(){
            histCounts.append(HistCounts(value: letter, index: index))
        }
        return Histogram(histogram: histCounts,word:word)
    }
    
    
    // Returns a list of suggestions given the frequency of characters
    func getPossibleWords(userInput: String) -> [Histogram]{
        var possibleWords: [Histogram] = []
        let inputtedWord = createHistogram(word: userInput).histogram

        var maxCounter = 0

        for word in self.dictionary {
            var matchedCounter = 0
            let word_histogram = createHistogram(word: word).histogram

            if userInput.count == word.count {
                for i in  0..<userInput.count {

                    if inputtedWord[i] == word_histogram[i] {
                        matchedCounter += 1
                    }
                }
                if matchedCounter == maxCounter {
                    maxCounter += 1
                    possibleWords.append(Histogram(histogram: word_histogram,word: word))
                }
                        

                if matchedCounter >= maxCounter {
                    maxCounter += 1
                    possibleWords = []
                    possibleWords.append(Histogram(histogram: word_histogram,word: word))
                }
            }
        }
        return possibleWords
    }
    
    // Last suggested word in histogram array is the most accurate
    func getLastSuggestWord(histograms: [Histogram] ) -> String {
        if let lastHist = histograms.last {
            return lastHist.word
        }
        return ""
    }
    
}
