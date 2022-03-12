//
//  StartViewController.swift
//  WWDC_Jump_AR
//
//  Created by admin on 2022/3/6.
//

import UIKit

class StartViewController: UIViewController {
    private let introducationText = UITextView(frame: .zero)
    private let hintText = UILabel()
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
        
        setupWelcomeImage()
        setupIntroducationText()
        setupHintText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupWelcomeImage() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.image = UIImage.init(named: "welcome.png")
        
    }
  
    private func setupIntroducationText() {
        self.view.addSubview(introducationText)
        introducationText.translatesAutoresizingMaskIntoConstraints = false
        introducationText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 190).isActive = true
        introducationText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        introducationText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        introducationText.textAlignment = .left
        introducationText.text = """
                                \tWelcome to Jump!\n
                                \tYou need to tap the screen to make the pieces fall into the next box, the score will increase by one for each successful jump, and the game ends if the jump fails.\n
                                \tWait a few seconds for the first time you enter the game.\n
                                \tSo please scroll down this page to start the game now!
                            """
        introducationText.textColor = UIColor.black
        introducationText.font = UIFont.init(name: "ArialRoundedMTBold", size: 20)
        introducationText.isScrollEnabled = false
        
    }
    
    private func setupHintText() {
        self.view.addSubview(hintText)
        hintText.translatesAutoresizingMaskIntoConstraints = false
        hintText.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        hintText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hintText.textAlignment = .center
        hintText.text = "Tips: Try to aim the camera at a flat surface！"
        hintText.textColor = UIColor.orange
        hintText.font = UIFont.systemFont(ofSize: 15)
    }
    
}
