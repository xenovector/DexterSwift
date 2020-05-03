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
    private init() {}
    
    static let SCREEN_RATIO_WIDTH = UIScreen.main.bounds.width / 414
    static let SCREEN_RATIO_HEIGHT = UIScreen.main.bounds.height / 896
    
    static let SUPER_LIGHT_GRAY: UIColor = .init(red: 220, green: 220, blue: 220)
    static let FACEBOOK_BLUE: UIColor = .init(red: 59, green: 89, blue: 152)
    static let GOOGLE_RED: UIColor = .init(red: 222, green: 82, blue: 70)

    static let KEY_LIVE = "LIVE"
    static let KEY_STAG = "STAG"
    static let KEY_DEVICE_ID = "DEVICE_ID"
    static let KEY_FCM_TOKEN = "FCM_TOKEN"
    static let KEY_ACCESS_TOKEN = "ACCESS_TOKEN"
    static let KEY_USER_ID = "USER_ID"
    static let KEY_APP_LANG = "APP_LANG"
    static let KEY_NOTIFICATION_COUNT = "NOTIFICATION_COUNT"
    static let KEY_ENABLE_ALWAYS_LOGIN = "ENABLE_ALWAYS_LOGIN"
    static let KEY_BIOMETRIC_TYPE = "BIOMETRIC_TYPE"

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
}

