//
//  ChessNode.swift
//  WWDC_Jump_AR
//
//  Created by admin on 2022/2/27.
//

//import UIKit
import SceneKit

class ChessNode: SCNNode {
    
//    private var isTouching = false
    private let chessHeight = 0.1
    private let chessMiniumHeight = 0.05
    private let radiusOfSphere = 0.02
    
    
    lazy var chessMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 0.95)
        return material
    }()
    
    lazy var coneNode: SCNNode = {
        let cone = SCNCone(topRadius: 0.02, bottomRadius: 0.03, height: chessHeight)
        cone.radialSegmentCount = 100
        cone.materials = [chessMaterial]
        return SCNNode(geometry: cone)
    }()
    
    lazy var sphereNode: SCNNode = {
        let sphere = SCNSphere(radius: radiusOfSphere)
        sphere.materials = [chessMaterial]
        return SCNNode(geometry: sphere)
    }()
        
    override init() {
        super.init()
        sphereNode.position = SCNVector3(0, Float(chessHeight)*0.75, 0)
        coneNode.addChildNode(sphereNode)
        self.addChildNode(coneNode)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isOnBox(boxNode: SCNNode) -> Bool {
        print(boxNode.geometry)
        if boxNode.geometry is SCNBox { // 长方体箱子
            let box = boxNode.geometry as! SCNBox
            let width = Float(box.width)
            if abs(self.position.x - boxNode.position.x) <= width/2 &&
                abs(self.position.z - boxNode.position.z) <= width/2 { // 跳到箱子上
                return true
            }
        } else if boxNode.geometry is SCNCylinder { // 圆柱形箱子
            if abs(self.position.x - boxNode.position.x) <= 0.1  &&
                abs(self.position.z - boxNode.position.z) <= 0.1 {
                return true
            }
        } else if boxNode.geometry is SCNCone { // 圆台形箱子
            if abs(self.position.x - boxNode.position.x) <= 0.08  &&
                abs(self.position.z - boxNode.position.z) <= 0.08 {
                return true
            }
        }
        
        return false
    }
    
    // 按压时棋子的动态变化
    public func reduce() {
        let chessGeometry = coneNode.geometry as! SCNCone
        if chessGeometry.height >= chessMiniumHeight {
            sphereNode.runAction(SCNAction.move(by: SCNVector3(0, -0.005, 0), duration: 0.2))
            coneNode.runAction(SCNAction.run({ _ in
                chessGeometry.height -= 0.005
            }))
        }
    }
    
    public func rise() {
        sphereNode.position = SCNVector3(0, Float(chessHeight)*0.8, 0)
        (coneNode.geometry as! SCNCone).height = chessHeight
    }
    
}
