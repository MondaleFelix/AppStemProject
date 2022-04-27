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
    
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchButton()
        configureTextField()
        configureSuggestionLabel()
        configureCollectionView()
        createDismissKeyboardTapGesture()
        searchButtonPressed()
        
    }
    
    
    // Returns image urls into useable UIimages
    func downloadPhotos(){
        downloadedImages = []
        for photo in photosList {
            NetworkManager.shared.downloadImage(from: photo.urls.regular) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case.success(let image):
                    self.downloadedImages.append(image)
                    if photo.urls.regular == self.photosList.last?.urls.regular {
                        DispatchQueue.main.async {
                            self.suggestionTextLabel.text = "Search Completed"
                            self.collectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    // Retrieves list of images from user input
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
    
    
    
    // Dismisses keyboard when view outside keyboard pressed
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    // Performs network request on users input
    @objc func searchButtonPressed(){

        // Handles empty input in Text Field
        guard var searchText = searchTextField.text?.lowercased() else {
            let errorAlert = UIAlertController(title: "Error", message: "Input is empty. Please enter an image", preferredStyle: UIAlertController.Style.alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
              }))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        

        searchText = removeSpecialCharsFromString(text: searchText)
        print(searchText)

        let possibleWordsHistograms = SuggestionManager.shared.getPossibleWords(userInput: searchText)
        let suggestedWord = SuggestionManager.shared.getLastSuggestWord(histograms: possibleWordsHistograms)
        
        
        // Suggestion alert
        let suggestionAlert = UIAlertController(title: "Suggestion", message: "Did you mean \(suggestedWord)", preferredStyle: UIAlertController.Style.alert)
        suggestionAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.getPhotos(query: suggestedWord)
            self.suggestionTextLabel.text = "Please Wait Images are being retrieved"
            self.searchTextField.text = suggestedWord
          }))

        suggestionAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            self.getPhotos(query: self.searchTextField.text!)
            self.suggestionTextLabel.text = "Please Wait Images are being retrieved"
            self.collectionView.reloadData()
          }))
        present(suggestionAlert, animated: true, completion: nil)
        
        

    }
    

    //Return input with non alphabet values removed
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    
    
    // MARK: Search Button
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
    
    
    // MARK: Search Text Field
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

    
    // MARK: Suggestion Label
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
    
    
    // MARK: Collection View
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

    // Returns insets to create a 3 image grid
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


// MARK: Text Field Delegate Methods

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        getPhotos(query: textField.text!)
        self.collectionView.reloadData()
        return true
    }
}

// MARK: Collection View Delegate and Datasource methods

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        let imageVC = ImageVC()
        imageVC.imageView.image = cell.photoImageView.image
        present(imageVC, animated: true)
        
    }
    
}



extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        let image = downloadedImages[indexPath.item]
        cell.photoImageView.image = image
        return cell
    }
    
    
}
