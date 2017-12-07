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
    
    //Add gesture de swip
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Fonction permettant lors du lachement du swip invoque la fonction d'ajout de fantome à la pos du lachage du swipe
    //Si 5 fantomes ne pas appeler l'ajout de fantome
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
    
    //Initialisation du terrain
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the scene to the view
        let arene = SCNScene(named: "art.scnassets/terrain.dae")!
//        let areneNode      = arene.rootNode.childNode(withName: "Camera", recursively: false)!
        
//        areneNode.position = SCNVector3(-15,-4,3)
        sceneView.scene = arene
//        print(areneNode)
        //Fonction lancé lors du swipe du fantome
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

