//
//  ASTextLabel.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

class ASTextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, textColor: UIColor) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = textColor
        configure()
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        
    }
    

}
