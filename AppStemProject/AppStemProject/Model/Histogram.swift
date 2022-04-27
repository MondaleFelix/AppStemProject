//
//  Histogram.swift
//  AppStemProject
//
//  Created by Mondale on 4/27/22.
//

import Foundation

class Histogram {

    var histogram: [HistCounts]
    var word: String

    init(histogram: [HistCounts], word:String) {
        self.histogram = histogram
        self.word = word
    }
}

class HistCounts: Equatable {
    static func == (lhs: HistCounts, rhs: HistCounts) -> Bool {
        return lhs.letter == rhs.letter && lhs.index == rhs.index
    }
    
    var letter: Character
    var index : Int
    
    init(value: Character, index: Int){
        self.letter = value
        self.index = index
    }
    
}
