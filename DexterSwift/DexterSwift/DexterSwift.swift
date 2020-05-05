//
//  DexterSwift.swift
//  DexterSwift
//
//  Created by ETC0018 on 02/05/2020.
//  Copyright © 2020 xenovector. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

public class DexterSwift {
    //private init() {}
    static let shared = General()
    
    private static var cancelPrint = false
    public static var cancelDexterPrint: Bool {
        set {
            DexterSwift.cancelPrint = newValue
        }
        get {
            return DexterSwift.cancelPrint
        }
    }
    
    public static let SCREEN_RATIO_WIDTH = UIScreen.main.bounds.width / 414
    static let SCREEN_RATIO_HEIGHT = UIScreen.main.bounds.height / 896
    
    public static let SUPER_LIGHT_GRAY: UIColor = .init(red: 220, green: 220, blue: 220)
    public static let FACEBOOK_BLUE: UIColor = .init(red: 59, green: 89, blue: 152)
    public static let GOOGLE_RED: UIColor = .init(red: 222, green: 82, blue: 70)

    public static let KEY_LIVE = "LIVE"
    public static let KEY_STAG = "STAG"
    public static let KEY_DEVICE_ID = "DEVICE_ID"
    public static let KEY_FCM_TOKEN = "FCM_TOKEN"
    public static let KEY_ACCESS_TOKEN = "ACCESS_TOKEN"
    public static let KEY_USER_ID = "USER_ID"
    public static let KEY_APP_LANG = "APP_LANG"
    public static let KEY_NOTIFICATION_COUNT = "NOTIFICATION_COUNT"
    public static let KEY_ENABLE_ALWAYS_LOGIN = "ENABLE_ALWAYS_LOGIN"
    public static let KEY_BIOMETRIC_TYPE = "BIOMETRIC_TYPE"

    // Message: - Public Message
    static let szForceUpdateTitle = "New Version Available"
    static let szForceUpdateMessage = "There is a newer version available for download. Please update the app by visiting the the App Store."
    static let szNoInternetMessage = "No Internet Connection, Please check your internet and try again."

    public enum BiometricType {
        case none
        case touchID
        case faceID
    }

    public static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                fatalError()
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    class Toast {
        private var labelBox: UILabel?
        private var timer: Timer?
        private var count = 0
        
        func makeText(_ your: UIViewController, withTitle title: String, _ duration: Int?) {
            DispatchQueue.main.async {
                let fixWidth = your.view.frame.width/5 * 4
                let sampleFrame = CGRect(x: Int(your.view.frame.midX), y: Int(your.view.frame.midY), width: Int(fixWidth), height: 35)
                let sampleBox = UILabel(frame: sampleFrame)
                sampleBox.numberOfLines = 10
                sampleBox.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
                sampleBox.text = title
                
                let newSize = sampleBox.sizeThatFits(CGSize.init(width: sampleBox.frame.size.width, height: CGFloat(MAXFLOAT))).height + 8
                
                let labelFrame = CGRect(x: Int(your.view.frame.midX-(fixWidth/2)), y: Int(your.view.frame.height - (newSize + 10)), width: Int(fixWidth), height: Int(newSize))
                self.labelBox = UILabel(frame: labelFrame)
                self.labelBox!.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
                self.labelBox!.numberOfLines = 30
                self.labelBox!.layer.cornerRadius = 14 //labelFrame.height/2
                self.labelBox!.layer.masksToBounds = true
                self.labelBox!.backgroundColor = .gray
                self.labelBox!.textColor = .groupTableViewBackground
                self.labelBox!.textAlignment = .center
                self.labelBox!.text = title
                self.labelBox!.alpha = 0
                
                UIView.animate(withDuration: 1.2, delay: 0, options: .showHideTransitionViews, animations: {
                    your.view.addSubview(self.labelBox!)
                    your.view.bringSubviewToFront(self.labelBox!)
                    self.labelBox!.alpha = 0.8
                })
                
                self.count = duration ?? 1
                self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
            }
        }
        
        @objc private func counter() {
            if self.count > 0 {
                self.count -= 1
            } else if count == 0 {
                self.timer?.invalidate()
                self.removeBox()
            }
        }
        
        private func removeBox() {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.2, delay: 0, options: .showHideTransitionViews, animations: {
                    self.labelBox?.alpha = 0
                }, completion: { (nil) in
                    self.labelBox?.removeFromSuperview()
                })
            }
        }
    }
    
    func getLangCode() -> String {
        var szLang = ""
        //let supposedLang = NSLocale.current.languageCode ?? ""
        let preferredLang = NSLocale.preferredLanguages.first ?? "en"
        let supposedLang = String(preferredLang.prefix(2))
        
        General.dexterPrint("supposedLang: \(supposedLang), preferredLang: \(preferredLang)")
        
        if supposedLang == "zh" {
            if preferredLang.hasPrefix("zh-Hans") {
                szLang = "zh-Hans"
            } else {
                szLang = "zh-Hant"
            }
        } else if preferredLang.hasPrefix("fil") {
            szLang = "fil-PH"
        } else if supposedLang == "id" {
            szLang = "id-ID"
        } else {
            szLang = supposedLang
        }
        
        return szLang
        
        /*if isLangSupport(szLang) == false {
            //szLang = "en"
        }*/
        
        /*if let currentLang = Share_x_Storage._x_shared.object(forKey: "LanguageCode") as? String {
            if currentLang == "" {
                Share_x_Storage._x_shared.set(szLang, forKey: "LanguageCode")
                return szLang
            }
            //if currentLang != szLang {
                //Share_x_Storage._x_shared.set(szLang, forKey: "LanguageCode")
                //return szLang
            //}
            return currentLang
        } else {
            Share_x_Storage._x_shared.set(szLang, forKey: "LanguageCode")
            return szLang
        }*/
    }
}

