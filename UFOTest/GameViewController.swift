//
//  GameViewController.swift
//  UFOTest
//
//  Created by Mikhail Petrenko on 11/21/18.
//  Copyright © 2018 Mikhail Petrenko. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    var sceneView:SCNView!
    var scene:SCNScene!
    override func viewDidLoad() {
        setupScene()
    }
    
    func setupScene(){
        sceneView = self.view as! SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "assets/MainScene.scn")
        sceneView.scene = scene
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
