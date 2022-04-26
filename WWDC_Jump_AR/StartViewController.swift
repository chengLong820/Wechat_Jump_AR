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
        imageView.contentMode = .center
        imageView.image = UIImage.init(named: "welcome.png")
        
    }
  
    private func setupIntroducationText() {
        self.view.addSubview(introducationText)
        introducationText.translatesAutoresizingMaskIntoConstraints = false
        introducationText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 190).isActive = true
        introducationText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        introducationText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        introducationText.backgroundColor = .white
        introducationText.textAlignment = .left
        introducationText.text = """
                                \tWelcome to ARJump!\n
                                \tYou need to tap the screen to make the pieces fall into the next box, the score will increase by one for each successful jump. The box will gradually get smaller，and the game ends if the jump fails.\n
                                \tClick anywhere to add a box. Wait a few seconds for the first time you enter the game.\n
                                \tSo please turn on sound and scroll down this page to start the game now!
                            """
        introducationText.textColor = UIColor.black
        introducationText.font = UIFont.init(name: "ArialRoundedMTBold", size: 20)
        introducationText.isScrollEnabled = false
        introducationText.isEditable = false
        
    }
    
    private func setupHintText() {
        self.view.addSubview(hintText)
        hintText.translatesAutoresizingMaskIntoConstraints = false
        hintText.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true
        hintText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hintText.textAlignment = .center
        hintText.text = "Make sure the camera is aimed at an open surface"
        hintText.textColor = UIColor.red
        hintText.font = UIFont.systemFont(ofSize: 18)
    }
    
}
