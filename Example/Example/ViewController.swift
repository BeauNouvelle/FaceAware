//
//  ViewController.swift
//  Example
//
//  Created by Beau Nouvelle on 17/9/16.
//

import UIKit
import FaceAware

class ViewController: UIViewController {

    @IBOutlet weak var faceAwareImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        faceAwareImageView.didFocusOnFaces = {
            print("Did finish focussing")
        }
    }

    @IBAction func toggle(_ sender: UIButton) {
        faceAwareImageView.focusOnFaces = !faceAwareImageView.focusOnFaces
    }
}
