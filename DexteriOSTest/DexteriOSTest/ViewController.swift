//
//  ViewController.swift
//  DexteriOSTest
//
//  Created by ETC0018 on 02/05/2020.
//  Copyright © 2020 xenovector. All rights reserved.
//

import UIKit
import DexterSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var testBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testBtn.backgroundColor = .black
        self.testBtn.setTitle("Test Button", for: .normal)
        self.testBtn.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        let v1 = "1.0.0"
        
    }


}

