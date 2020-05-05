//
//  ViewController.swift
//  Example
//
//  Created by ETC0018 on 05/05/2020.
//  Copyright © 2020 xenovector. All rights reserved.
//

import UIKit
import DexterSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var testBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pod 'DexterSwift', :path => "../DexterSwift/"
        var UI_isDark = false
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                UI_isDark = true
            }
        }
        self.testBtn.backgroundColor = UI_isDark ? .white : .black
        self.testBtn.setTitle("Test Button", for: .normal)
        self.testBtn.setTitleColor(UI_isDark ? .black : .white, for: .normal)
        self.testBtn.layer.cornerRadius = 5
        self.testBtn.layer.masksToBounds = true
        DispatchQueue.main.async {
            self.testBtn.applyShadow(radius: 3, shadowColor: .white)
        }
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        //let v1 = "1.0.0"
        _ = DexterSwift.general.AppInfo().version
    }
    
    /*
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    */
}

