//
//  ViewController.swift
//  AppStemProject
//
//  Created by Mondale on 4/21/22.
//

import UIKit
import Foundation

class SearchVC: UIViewController {

    let searchTextField = ASTextField()
    let searchButton = ASButton(backgroundColor: .systemBlue, title: "GO")
    let suggestionTextLabel = ASTextLabel(textAlignment: .left, textColor: .systemBlue)
    var collectionView: UICollectionView!
    var photosList: [Photo] = []
    var downloadedImages: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchButton()
        configureTextField()
        configureSuggestionLabel()
        createDismissKeyboardTapGesture()
        configureCollectionView()

        
    }
    
    func downloadPhotos(){

        for photo in photosList {
            NetworkManager.shared.downloadImage(from: photo.src.original) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case.success(let image):

                    self.downloadedImages.append(image)
                    if photo.src.original == self.photosList.last?.src.original {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }

    }
    
    
    
    func getPhotos(query: String){
        NetworkManager.shared.getPhotos(for: query) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case.success(let photos):
                self.photosList = photos
                self.downloadPhotos()
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func searchButtonPressed(){
        // TODO: Network request when button pressed
        getPhotos(query: searchTextField.text!)
        self.collectionView.reloadData()
    }
    
    
    
    private func configureSearchButton(){
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4),
            searchButton.heightAnchor.constraint(equalToConstant: 35),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        
        
        ])
    }
    
    private func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    
    private func configureSuggestionLabel(){
        view.addSubview(suggestionTextLabel)
        suggestionTextLabel.text = ""
        
        NSLayoutConstraint.activate([
            suggestionTextLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            suggestionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            suggestionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            suggestionTextLabel.heightAnchor.constraint(equalToConstant: 20)
        
        
        ])
        
    }
    
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: suggestionTextLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        
        ])
    }

    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width - 40 
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Network request when keyboard return pressed
            // Filter TextField Value
            // Make network request to API with value
        getPhotos(query: textField.text!)
        self.collectionView.reloadData()
        return true
    }
}

extension SearchVC: UICollectionViewDelegate {
    
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        if downloadedImages.count != photosList.count{
            return cell
        }
        print(indexPath.row)
        let image = downloadedImages[indexPath.item]
        cell.photoImageView.image = image
        return cell
    }
    
    
}
