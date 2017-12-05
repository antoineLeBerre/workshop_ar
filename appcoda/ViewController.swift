//
//  ViewController.swift
//  appcoda
//
//  Created by eemi on 05/12/2017.
//  Copyright © 2017 eemi. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    //Connecting the view
    @IBOutlet var sceneView: ARSCNView!

    //start world tracking when the view launch
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    //Stop world tracking when the view close
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //Create a box
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
//        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        let url = URL(fileURLWithPath: "art.scnassets/ship.scn")
        let coder = NSCoder()
        let src = SCNSceneSource()
        let data = Data()
        let point = CGPoint(from: "art.scnassets/ship.scn" as! Decoder)
        let src2 = SCNGeometrySource()
        let box = SCNGeometry(sources: [], elements: nil)
//        box.sources = "art.scnassets/ship.scn"
        let boxNode = SCNNode()
        boxNode.geometry = box
        
        //boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    //Add gesture
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBox()
        addTapGestureToSceneView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

