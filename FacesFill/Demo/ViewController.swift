//
//  ViewController.swift
//  FacesFill
//
//  Created by Beau Nouvelle on 22/7/16.
//  Copyright © 2016 Pear Pi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var normal: UIImageView!
    @IBOutlet weak var faceAware: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faceAware.focusOnFaces()
    }
    
}

