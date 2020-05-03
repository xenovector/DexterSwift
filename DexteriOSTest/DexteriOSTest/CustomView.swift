//
//  CustomView.swift
//  DexterWorkPackages
//
//  Created by ETC0018 on 03/02/2020.
//  Copyright © 2020 XenoVector. All rights reserved.
//

import Foundation
import UIKit

public class CustomView: UIView {
    
    // MARK: Properties
    let nibName = "CustomView"
    var contentView: UIView!
    
    // MARK: Init
    public override init(frame: CGRect) {
     // For use in code
      super.init(frame: frame)
      setUpView()
    }

    public required init?(coder aDecoder: NSCoder) {
       // For use in Interface Builder
       super.init(coder: aDecoder)
      setUpView()
    }
    
    // MARK: Set Up View
    func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    public func set(image: UIImage) {
        //self.statusImage.image = image
    }
     public func set(headline text: String) {
        //self.headlineLabel.text = text
    }
    public func set(subheading text: String) {
        //self.subheadLabel.text = text
    }
}
