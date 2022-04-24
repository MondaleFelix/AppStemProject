//
//  ASButton.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

class ASButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints  = false
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
}


