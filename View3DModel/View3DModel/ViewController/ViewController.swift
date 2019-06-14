//
//  ViewController.swift
//  View3DModel
//
//  Created by William-Weng on 2019/2/19.
//  Copyright © 2019年 William-Weng. All rights reserved.
//
/// [iOS - SceneKit顯示與交互3D建模（一）](https://www.jianshu.com/p/df7514a6cb91)
/// [SceneKit | 加載 3D模型(obj/scn/dae)到你的AR項目中](https://www.jianshu.com/p/15101aa0eefe)
/// [SceneKit開發關於加載obj格式文件的處理](https://www.jianshu.com/p/6a761a834ab9)

import UIKit
import SceneKit

// MARK: - SceneDelegate
protocol SceneDelegate: AnyObject {
    
    /// 更新場景
    func updataScene(_ scene: SCNScene?)
}

// MARK: - ViewController
class ViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = modelScene(with: "Minion.scn")
        let cameraNode = cameraNodeMaker()
        let lightNode = lightNodeMaker(with: .ambient, lightColor: .gray)
        
        scene?.rootNode.addChildNode(cameraNode)
        scene?.rootNode.addChildNode(lightNode)

        scnView.scene = scene
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
              identifier == "FileViewSegue",
              let fileViewController = segue.destination as? FileViewController
        else {
            return
        }
        
        fileViewController.myDelegate = self
    }
    
    deinit {
        print("ViewController deinit")
    }
}

// MARK: - SceneDelegate
extension ViewController: SceneDelegate {
    
    func updataScene(_ scene: SCNScene?) {
        scene?.rootNode.geometry?.firstMaterial?.lightingModel = .lambert
        scnView.scene = scene
    }
}

// MARK: - 小工具
extension ViewController {

    /// 取得場景
    private func modelScene(with filename: String) -> SCNScene? {
        
        let scene = SCNScene(named: "Model.scnassets/\(filename)")

        scnView.backgroundColor = .gray
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true

        return scene
    }
    
    /// 相機節點
    private func cameraNodeMaker() -> SCNNode {
        
        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 5, 15);
        
        return cameraNode
    }
    
    /// 燈光節點
    private func lightNodeMaker(with type: SCNLight.LightType, lightColor: UIColor) -> SCNNode {
        
        let lightNode = SCNNode()
    
        lightNode.light = SCNLight()
        lightNode.light?.type = type
        lightNode.position = SCNVector3Make(10, 10, 10)
        lightNode.light?.color = lightColor.cgColor

        return lightNode
    }
}

