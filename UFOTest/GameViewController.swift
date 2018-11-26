//
//  GameViewController.swift
//  UFOTest
//
//  Created by Mikhail Petrenko on 11/21/18.
//  Copyright © 2018 Mikhail Petrenko. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var gameView:SCNView!
    var gameScene:SCNScene!
    var cameraControl:SCNNode!
    var ballNode:SCNNode!
    var motion = MotionHelper()
    var motionForce = SCNVector3(0,0,0)
    var sounds:[String:SCNAudioSource] = [:]
    
    override func viewDidLoad() {
        setup()
        setupNodes()
        audioSetup()
    }
    
    func setup(){
        gameView = self.view as! SCNView
//        gameView.allowsCameraControl = true
        gameScene = SCNScene(named: "assets/MainScene.scn")
        gameView.scene = gameScene
        let tapRec = UITapGestureRecognizer()
        tapRec.numberOfTapsRequired = 1
        tapRec.numberOfTouchesRequired = 1
        tapRec.addTarget(self, action: #selector(GameViewController.sceneTapped(recognizer:)))
        gameView.addGestureRecognizer(tapRec)
        gameView.delegate = self
    }
    func setupNodes(){
        ballNode = gameScene.rootNode.childNode(withName: "ball", recursively: true)!
        cameraControl = gameScene.rootNode.childNode(withName: "cameraControl", recursively: true)!
    }
    func audioSetup(){
        let bounceSound = SCNAudioSource(fileNamed: "assets/bounce.mp3")!
        bounceSound.load()
        bounceSound.volume = 0.5
        let backSound = SCNAudioSource(fileNamed: "assets/back.mp3")!
        backSound.load()
        backSound.volume = 0.01
        backSound.loops = true
        let musicPlayer = SCNAudioPlayer(source: backSound)
        sounds["bounce"] = bounceSound
        sounds["back"] = backSound
        ballNode.addAudioPlayer(musicPlayer)
        
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        sceneTapped(recognizer: touches)
//    }
    
    @objc func sceneTapped(recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: gameView)
        let hits = gameView.hitTest(location, options: nil)
        if hits.count > 0 {
            print("hit count")
            let result = hits.first
            if let node = result?.node{
                print("hit node")

                if node.name == "ball"{
                    print("node is ball")

                    let jmpSnd = sounds["bounce"]!
                    ballNode.runAction(SCNAction.playAudio(jmpSnd, waitForCompletion: false))
                    ballNode.physicsBody?.applyForce(SCNVector3(0,3,-2), asImpulse: true)
                }
            }
        }
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    

    


}

extension GameViewController : SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let ball = ballNode.presentation
        let ballposition = ball.position
        
        let targetPos = SCNVector3(x: ballposition.x, y: ballposition.y, z: ballposition.z)
        var cameraPos = cameraControl.position
        let damping:Float = 0.3
        let xComp = cameraPos.x * (1-damping) + targetPos.x * damping
        let yComp = cameraPos.y * (1-damping) + targetPos.y * damping
        let zComp = cameraPos.z * (1-damping) + targetPos.z * damping

        cameraPos = SCNVector3(x: xComp, y: yComp, z: zComp)
        cameraControl.position = cameraPos
        
    }
}
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x:left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}


func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}
