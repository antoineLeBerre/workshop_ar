//
//  ViewController.swift
//  appcoda
//
//  Created by eemi on 05/12/2017.
//  Copyright © 2017 eemi. All rights reserved.
//  Inspired by : https://www.appcoda.com/arkit-introduction-scenekit/

import UIKit
import ARKit
import SceneKit
import QuartzCore

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    //Connecting the view
    @IBOutlet weak var sceneView: ARSCNView!
    // Initialisation du nombre de fantome
    var nbFantome = 0
    var arene:SCNScene?
    
    //start world tracking when the view launch
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
    
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }
    //Stop world tracking when the view close
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // Create scene when the application appear
    override func viewDidAppear(_ animated: Bool) {
        // Ajout de la node landscape de l'arene
        let areneNode = arene?.rootNode.childNode(withName: "Landscape", recursively: false)!
        areneNode?.position = SCNVector3(0,-3,-10)
        arene?.rootNode.addChildNode(areneNode!)
        // Ajout de l'arene dans la scene
        sceneView.scene = arene!
        
        //Fonction lancé lors du tap sur l'écran
        addTapGestureToSceneView()
    }
    
    
    //Create a box
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        //On trouve la scene
        let ship          = SCNScene(named: "art.scnassets/ghosti.scn")!
        //On recupere le node du fantome
        let shipNode      = ship.rootNode.childNode(withName: "Layer0_001", recursively: false)!
        shipNode.position = SCNVector3(x, y, z)
        shipNode.scale = SCNVector3(0.001, 0.001, 0.001)
        //On charge l'objet dans dans le node
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
    //Add gesture du click
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
                if nbFantome < 5 {
                    nbFantome += 1
                    addBox(x: translation.x, y: translation.y, z: translation.z)
                } else {
                    return
                }
            }
            return
        }
        //nbFantome -= 1
        //node.removeFromParentNode()
    }
    
    //Initialisation du terrain
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // on met le terran dans la variable arene
        arene = SCNScene(named: "art.scnassets/terrain.scn")!
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

