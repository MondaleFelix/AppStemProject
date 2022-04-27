//
//  PhotoCell.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    
    static let reuseID = "PhotoCell"
    var photoImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        contentView.layer.cornerRadius = 10
        photoImageView.layer.cornerRadius = 10
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        contentView.backgroundColor = .systemGray5
        isUserInteractionEnabled = true

    
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }


}
