//
//  ViewController.swift
//  AppStemProject
//
//  Created by Mondale on 4/21/22.
//

import UIKit

class SearchVC: UIViewController {

    let searchTextField = ASTextField()
    let searchButton = ASButton(backgroundColor: .systemBlue, title: "GO")
    let suggestionTextLabel = ASTextLabel(textAlignment: .left, textColor: .systemBlue)
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchButton()
        configureTextField()
        configureSuggestionLabel()
        createDismissKeyboardTapGesture()
        getPhotos()
    }
    
    func getPhotos(){
        NetworkManager.shared.getPhotos(for: "Lemon") { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case.success(let photos):
                print(photos)
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
        print(searchTextField.text ?? "No Input")
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
        suggestionTextLabel.text = "Did you mean eggs?"
        
        NSLayoutConstraint.activate([
            suggestionTextLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            suggestionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            suggestionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            suggestionTextLabel.heightAnchor.constraint(equalToConstant: 20)
        
        
        ])
        
    }

    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Network request when keyboard return pressed
            // Filter TextField Value
            // Make network request to API with value
        print("This is working")
        return true
    }
}
