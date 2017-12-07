//
//  ViewController.swift
//  appcoda
//
//  Created by eemi on 05/12/2017.
//  Copyright © 2017 eemi. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, ARSCNViewDelegate {
    //Connecting the view
    @IBOutlet weak var sceneView: ARSCNView!
    
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
        //On trouve la scene
        let ship          = SCNScene(named: "art.scnassets/ship.scn")!
        //On trouve les données geometrique de la scene
        let shipNode      = ship.rootNode.childNode(withName: "ship", recursively: false)!
        shipNode.position = SCNVector3(x, y, z)
        //On charge l'objet dans dans le node
        sceneView.scene.rootNode.addChildNode(shipNode)
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
        
        // Set the scene to the view
        let arene = SCNScene(named: "art.scnassets/terraun-sombre.scn")!
        
        sceneView.scene = arene
        addTapGestureToSceneView()
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

