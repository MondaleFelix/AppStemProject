//
//  ASTextField.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

class ASTextField: UITextField {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.borderColor = UIColor.systemGray2.cgColor
        
        placeholder = "Search"
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title3)
        
        backgroundColor             = .tertiarySystemBackground
        autocorrectionType          = .no
    
    }

}
