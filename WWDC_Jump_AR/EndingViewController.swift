//
//  EndingViewController.swift
//  WWDC_Jump_AR
//
//  Created by admin on 2022/3/5.
//

import UIKit

class EndingViewController: UIViewController {
    
    private let failLabel = UILabel()
    private let highestScoreLabel = UILabel()
    private let nowScoreLabel = UILabel()
    private let restartBtn = UIButton()
    
    private let highestScoreKeyString = "HighestScoreKey"
    public var nowScore = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        setupFailLabel()
        setupNowScoreLabel()
        setupHighestScoreLabel()
        setupRestartBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupFailLabel() {
        self.view.addSubview(failLabel)
        failLabel.translatesAutoresizingMaskIntoConstraints = false
        failLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        failLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        failLabel.text = "You Fail!"
        failLabel.textColor = UIColor.red
        failLabel.font = UIFont.init(name: "ArialRoundedMTBold", size: 60) //AmericanTypewriter-Bold
    }
    
    private func setupNowScoreLabel() {
        self.view.addSubview(nowScoreLabel)
        nowScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nowScoreLabel.topAnchor.constraint(equalTo: failLabel.bottomAnchor, constant: 40).isActive = true
        nowScoreLabel.centerXAnchor.constraint(equalTo: failLabel.centerXAnchor).isActive = true
        nowScoreLabel.text = String(nowScore)
        nowScoreLabel.font = UIFont.init(name: "ArialRoundedMTBold", size: 75)
        nowScoreLabel.textColor = UIColor.white
    }
    
    private func setupHighestScoreLabel() {
        self.view.addSubview(highestScoreLabel)
        highestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highestScoreLabel.topAnchor.constraint(equalTo: nowScoreLabel.bottomAnchor, constant: 50).isActive = true
        highestScoreLabel.centerXAnchor.constraint(equalTo: nowScoreLabel.centerXAnchor).isActive = true
        highestScoreLabel.text = "Highest Score: \(UserDefaults.standard.integer(forKey: highestScoreKeyString))"
        highestScoreLabel.font = UIFont.init(name: "ArialRoundedMTBold", size: 35)
        highestScoreLabel.textColor = UIColor.white
    }

    private func setupRestartBtn() {
        self.view.addSubview(restartBtn)
        restartBtn.frame.size = CGSize(width: 80, height: 20)
        restartBtn.translatesAutoresizingMaskIntoConstraints = false
        restartBtn.topAnchor.constraint(equalTo: highestScoreLabel.bottomAnchor, constant: 80).isActive = true
        restartBtn.centerXAnchor.constraint(equalTo: highestScoreLabel.centerXAnchor).isActive = true
        restartBtn.setTitle("  Restart  ", for: .normal)
        restartBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        restartBtn.setTitleColor(UIColor.black, for: .normal)
        restartBtn.backgroundColor = UIColor.white
        restartBtn.layer.cornerRadius = 8
        restartBtn.addTarget(self, action: #selector(clickRestartBtn), for: .touchUpInside)
    }
    
    @objc func clickRestartBtn() {
        let btnIsClicked = true
        NotificationCenter.default.post(name: Notification.Name("clickButtonNotification"), object: btnIsClicked)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
