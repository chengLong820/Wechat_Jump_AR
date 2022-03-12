//
//  ViewController.swift
//  WWDC_Jump_AR
//
//  Created by admin on 2022/2/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    private var currentAnchor: ARAnchor? // 当前锚点
    private var scoreLabel = UILabel()
    
    private let boxHeight: CGFloat = 0.2 // 箱子高度
    private var boxNodeArr: [SCNNode] = [] // 当前箱子数组
    private let boxRadius = 0.1
    
    lazy var chessNode: ChessNode = {
       return ChessNode()
    }()
    
    // 触摸事件
    private var isTouching = false
    private var randomDirection: RandomDirection = .up // 随机方向
    private var touchingTime: (start: TimeInterval, end: TimeInterval) = (0, 0)
    private let flyingTimeOfChess: TimeInterval = 0.5
    private let flyingheightOfChess = 0.2
    // 分数统计
    private let highestScoreKeyString = "HighestScoreKey"
    private var highestScore = 0
    public var nowScore = 0
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        setupScoreLabel()

        DispatchQueue.main.async {
            self.pushStartViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        restart()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func pushStartViewController() {
        let startVC = StartViewController()
        let topVC = getTopMostViewController()
        topVC?.present(startVC, animated: true, completion: {
            self.restart()
        })
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    private func setupScoreLabel() {
        highestScore = UserDefaults.standard.integer(forKey: highestScoreKeyString)
        self.sceneView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.init(name: "ArialRoundedMTBold", size: 45)
        scoreLabel.textColor = UIColor.white
        scoreLabel.textAlignment = .center
        scoreLabel.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 50).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        scoreLabel.numberOfLines = 2
        scoreLabel.text = "Highest:\(highestScore)\nNow:\(nowScore)"
    }
    
    public func restart() {
        isTouching = false
        touchingTime = (0, 0)
        boxNodeArr.forEach { boxNode in
            boxNode.removeFromParentNode()
        }
        boxNodeArr.removeAll()
        chessNode.removeFromParentNode()
        nowScore = 0
        setupScoreLabel()
        let action = SCNAction.fadeIn(duration: 0.5)
        action.timingMode = SCNActionTimingMode.easeIn
        chessNode.runAction(action)

    }
    
    // 生成棋子
    private func addChess() {
        chessNode.position = SCNVector3(boxNodeArr.last!.position.x, boxNodeArr.last!.position.y + Float(boxHeight) * 0.5, boxNodeArr.last!.position.z)
        sceneView.scene.rootNode.addChildNode(chessNode)
    }
    
    // 生成箱子
    private func addBox(at realPosition: SCNVector3) {
        // 生成箱子
        let randomNumber = Int.random(in: 1...100)
        let box: SCNGeometry
        if randomNumber%3 == 0 { // 长方体箱子
            box = SCNBox(width: boxHeight, height: boxHeight / 2, length: boxHeight, chamferRadius: 0.0)
        } else if randomNumber%3 == 1{ // 圆柱形箱子
            box = SCNCylinder(radius: boxRadius, height: boxHeight / 2)
        } else { // 圆台形箱子
            box = SCNCone(topRadius: 0.08, bottomRadius: boxHeight/2, height: boxHeight/2)
        }

        let node = SCNNode(geometry: box)
        // 设置箱子颜色
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = UIColor(red: CGFloat(Float.random(in: 0...1)), green: CGFloat(Float.random(in: 0...1)), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        box.materials = [material]
        
        if boxNodeArr.isEmpty { // 初始化游戏
            node.position = realPosition
        } else {
            // 随机方向
            randomDirection = RandomDirection(rawValue: Int(arc4random() % 2))!
            // 随机距离(0.3 - 0.5)
            let randomDistance = Double.random(in: 0.3...0.5)
            
            if randomDirection == .right {
                node.position = SCNVector3(x: realPosition.x + Float(randomDistance), y: realPosition.y, z: realPosition.z)
            } else {
                node.position = SCNVector3(x: realPosition.x, y: realPosition.y, z: realPosition.z + Float(randomDistance))
            }
        }
        sceneView.scene.rootNode.addChildNode(node)
        boxNodeArr.append(node)
        
    }
    
    // 检测点击，并转换成三维虚拟世界坐标
    private func getHitPosition(hitLocation: CGPoint) -> SCNVector3? {
        let results = sceneView.hitTest(hitLocation, types: .featurePoint)
        if results.isEmpty {
            return nil
        }
        return SCNVector3Make(results[0].worldTransform.columns.3.x,
                              results[0].worldTransform.columns.3.y,
                              results[0].worldTransform.columns.3.z)
        
    }
    
    // 检测点击事件开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentAnchor == nil { return  }
        
        if boxNodeArr.isEmpty { // 初始化游戏
            let hitLocation = touches.first?.location(in: sceneView)
            if let position = getHitPosition(hitLocation: hitLocation!) {
                addBox(at: position)
                addChess()
                addBox(at: boxNodeArr.last!.position)
            }
        } else {
            if !isTouching {
                isTouching = true
            }
            touchingTime.start = (event?.timestamp)!
        }
    }
    
    // 检测点击事件结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentAnchor == nil && boxNodeArr.isEmpty {
            return
        }
        if isTouching {
            isTouching = false
            touchingTime.end = (event?.timestamp)!
            
            // 棋子飞行距离
            let distanceOfChess = (touchingTime.end - touchingTime.start) * 0.4
            
            // 飞行动画
            var actions = [SCNAction()]
            if randomDirection == .right {
                let action1 = SCNAction.moveBy(x: distanceOfChess, y: flyingheightOfChess, z: 0, duration: flyingTimeOfChess / 2)
                let action2 = SCNAction.moveBy(x: distanceOfChess, y: -flyingheightOfChess, z: 0, duration: flyingTimeOfChess / 2)
                actions = [SCNAction.rotateBy(x: 0, y: 0, z: .pi * 2, duration: flyingTimeOfChess),
                           SCNAction.sequence([action1, action2])]
            } else {
                let action1 = SCNAction.moveBy(x: 0, y: flyingheightOfChess, z: distanceOfChess, duration: flyingTimeOfChess / 2)
                let action2 = SCNAction.moveBy(x: 0, y: -flyingheightOfChess, z: distanceOfChess, duration: flyingTimeOfChess / 2)
                actions = [SCNAction.rotateBy(x: .pi * 2, y: 0, z: 0, duration: flyingTimeOfChess),
                           SCNAction.sequence([action1, action2])]
            }
            
            chessNode.rise()
            chessNode.runAction(SCNAction.group(actions), completionHandler: {
                if self.chessNode.isOnBox(boxNode: self.boxNodeArr.last!) {
                    self.nowScore += 1
                    if self.nowScore > self.highestScore {
                        UserDefaults.standard.set(self.nowScore, forKey: self.highestScoreKeyString)
                    }
                    DispatchQueue.main.async {
                        self.scoreLabel.text = "Highest:\(self.highestScore)\nNow:\(self.nowScore)"
                    }
                    self.addBox(at: self.boxNodeArr.last!.position)
                } else {
                    DispatchQueue.main.async {
                        self.scoreLabel.isHidden = true
                        let endingVC = EndingViewController()
                        endingVC.isModalInPresentation = true
                        endingVC.nowScore = self.nowScore
                        self.present(endingVC, animated: true, completion: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.restartBtnIsClicked), name: Notification.Name("clickButtonNotification"), object: nil)
                    }
                }
            })
        }
    }
    
    @objc func restartBtnIsClicked() {
        self.scoreLabel.isHidden = false
        self.restart()
    }
    
    
    

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if currentAnchor == nil {
            currentAnchor = anchor
            
            // 设置点光源
            let light = SCNLight()
            light.type = .omni
            light.color = UIColor.white
            let lightNode = SCNNode()
            lightNode.position = SCNVector3(node.position.x, node.position.y + 0.2, node.position.z)
            lightNode.light = light
            self.sceneView.scene.rootNode.addChildNode(lightNode)

        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if isTouching {
            chessNode.reduce()
        }
        
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
