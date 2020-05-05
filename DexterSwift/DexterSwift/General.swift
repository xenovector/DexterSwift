//
//  General.swift
//  propsell
//
//  Created by ETC0018 on 15/01/2020.
//  Copyright © 2020 PropSell. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class DexterGeneral {
    //public static let shared = DexterGeneral()
    private let defaults = UserDefaults.standard
    //let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
    var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.keyWindow
        }
    }
    
    static func dexterPrint(_ text: String?) {
        if !DexterSwift.cancelDexterPrint {
            print("[DexterSwift]: " + (text ?? "nil"))
        }
    }
    
    public func AppInfo() -> (version: String, build: Int) {
        let bundleInfo = Bundle.main.infoDictionary!
        let szBuild = bundleInfo["CFBundleVersion"] as! String
        let szVersion = bundleInfo["CFBundleShortVersionString"] as! String
        //if live == false {
            DexterGeneral.dexterPrint("szVersion: \(szVersion),  szBuild: \(szBuild)")
        //}
        return (szVersion, Int(szBuild) ?? 0)
    }
    
    public func getDeviceInfo() {
        let device = UIDevice.current
        let deviceName = device.name
        let iosName = device.systemName
        let iosVersion = device.systemVersion
        let deviceModel = device.model
        let deviceModelName = UIDevice.model_Name
        let localizeModel = device.localizedModel
        let userInterfaceType = device.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? "iPhone" : device.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? "iPad" : "unknown device type"
        let deviceUUID = String(describing: device.identifierForVendor)
        let freeSpace = device.getFreeSize()
        let totalSpace = device.getTotalSize()
        
        device.isBatteryMonitoringEnabled = true
        let b_level = device.batteryLevel * 100
        DexterGeneral.dexterPrint("battery percentage: \(b_level)")
        DexterGeneral.dexterPrint("DeviceInfo:\ndeviceName: \(deviceName)\niOSName: \(iosName)\niOSVersion: \(iosVersion)\ndeviceModel: \(deviceModel)\ndeviceModelName: \(deviceModelName)\nlocalizeModel: \(localizeModel)\nuserInterfaceType: \(userInterfaceType)\ndeviceUUID: \(deviceUUID)")
        DexterGeneral.dexterPrint("freeSpace: \(freeSpace.rounded().decimalTo(0)) GB")
        DexterGeneral.dexterPrint("totalSpace: \(totalSpace.rounded().decimalTo(0)) GB")
    }
    
    public func noInternet(_ vc: UIViewController, handle: @escaping (UIAlertAction) -> Void)
    {
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: nil, message: DexterSwift.szNoInternetMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: handle))
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    public func showAlert(vc: UIViewController, title: String?, message: String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(vc: UIViewController, title: String?, message: String?, handle: @escaping (UIAlertAction) -> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handle))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func showImageAlert(vc: UIViewController, image: UIImage?, title: String?, handle: @escaping (UIAlertAction) -> Void) {
        let spaceText = "\n\n\n\n\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: spaceText + (title ?? "Are you sure to choose this photo?"), message: nil, preferredStyle: .alert)
        let imgViewTitle = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 270))
        imgViewTitle.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        imgViewTitle.contentMode = .scaleAspectFill
        imgViewTitle.image = image
        alert.view.addSubview(imgViewTitle)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: handle))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func showConfirmAlert(vc: UIViewController, title: String?, message: String?, confirmText: String = "Yes", cancelText: String = "Cancel", confirmHandle: @escaping (UIAlertAction) -> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmText, style: .default, handler: confirmHandle))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func showConfirmAlert(vc: UIViewController, title: String?, message: String?, confirmText: String = "Yes", cancelText: String = "Cancel", confirmHandle: @escaping (UIAlertAction) -> Void, cancelHandle: @escaping (UIAlertAction) -> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .default, handler: cancelHandle))
        alert.addAction(UIAlertAction(title: confirmText, style: .default, handler: confirmHandle))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func getTodayDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        //let date = dateFormat.date(from: "2019-06-17")!
        return dateFormat.string(from: Date())
    }
    
    public func convertDate(dateString: String, returnPattern:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        if let dateFromString = formatter.date(from: dateString) {
            formatter.dateFormat = returnPattern
            let stringFromDate = formatter.string(from: dateFromString)
            return stringFromDate
        }
        return ""
    }
    
    public func convertDate(dateString:String, returnPattern:String, datePattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = datePattern
        // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        if let dateFromString = formatter.date(from: dateString) {
            formatter.dateFormat = returnPattern
            let stringFromDate = formatter.string(from: dateFromString)
            return stringFromDate
        }
        return ""
    }
    
    var noticeAVPlayer: AVAudioPlayer?
    public func playSound(_ resource: String) {
        let url = Bundle.main.url(forResource: resource, withExtension: "mp3")!
        do {
            noticeAVPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = noticeAVPlayer else { return }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            DexterGeneral.dexterPrint(error.description)
        }
    }
    
    public func getCurrentTimeMillis() -> Int64 {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let nanoseconds = calendar.component(.nanosecond, from: date)
        let uniqueInt = Int64(String(hours) + String(minutes) + String(seconds) + String(nanoseconds))
        return uniqueInt ?? 0
    }
    
    private var lUniqueIncreasement: Int64 = 0
    public func getUniqueInt64() -> Int64 {
        let timeStamp = Date().timeIntervalSince1970
        let lTimeStamp = Int64(timeStamp)
        
        if lUniqueIncreasement == 0 {
            let lRandom = Int64.random(in: 0...1000000000)
            lUniqueIncreasement = (lTimeStamp % 1000000000) + lRandom
        }
        
        lUniqueIncreasement += 1
        if lUniqueIncreasement>=1000000000 { lUniqueIncreasement=(lUniqueIncreasement % 1000000000)+1 }
        let lUnique = ((lTimeStamp % 9223000000) * 1000000000) + lUniqueIncreasement
        DexterGeneral.dexterPrint("lUnique: \(lUnique)\n")
        return lUnique
    }
    
    public func getUniqueName() -> String {
        return String(getUniqueInt64())
    }
    
    public func showSettingAlert(vc: UIViewController?, title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ignore", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Setting", style: .default, handler: { (action:UIAlertAction) in
            self.openSettings()
        }))
        if vc == nil {
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)
            }
        } else {
            vc!.present(alert, animated: true, completion: nil)
        }
    }
    
    public func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                DexterGeneral.dexterPrint("Settings opened: \(success)")
            })
        }
    }
    
    public func openURL(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
    public func getFileName(_ szFilePath: String) -> String {
        if szFilePath == "" {
            return ""
        } else {
            let x = szFilePath.range(of: "/", options: .backwards)?.lowerBound
            if x == nil {
                return szFilePath
            } else {
                return String(szFilePath[szFilePath.index(after: x!)...])
            }
        }
    }
    
    public func faceDetect(_ ImgToDetect: UIImage) -> Bool {
        let value: Int?
        switch ImgToDetect.imageOrientation {
        case UIImage.Orientation.up:
            DexterGeneral.dexterPrint("orientation up // 1")
            value = 1
        case UIImage.Orientation.down:
            DexterGeneral.dexterPrint("orientation down // 3")
            value = 3
        case UIImage.Orientation.left:
            DexterGeneral.dexterPrint("orientation left // 8")
            value = 8
        case UIImage.Orientation.right:
            DexterGeneral.dexterPrint("orientation right // 6")
            value = 6
        case UIImage.Orientation.upMirrored:
            DexterGeneral.dexterPrint("orientation upMirrored // 2")
            value = 2
        case UIImage.Orientation.downMirrored:
            DexterGeneral.dexterPrint("orientation downMirrored // 4")
            value = 4
        case UIImage.Orientation.leftMirrored:
            DexterGeneral.dexterPrint("orientation leftMirrored // 5")
            value = 5
        case UIImage.Orientation.rightMirrored:
            DexterGeneral.dexterPrint("orientation rightMirrored // 7")
            value = 7
        @unknown default:
            fatalError()
        }
        //General.dexterPrint("value: \(String(describing: value))")
        let imageOptions =  NSDictionary(object: NSNumber(value: value!) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let personciImage = CIImage(cgImage: ImgToDetect.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage, options: imageOptions as? [String : AnyObject])
        if let _ = faces?.first as? CIFaceFeature {
            //print("found bounds are \(face.bounds)")
            //if faces!.count != 0 { }
            DexterGeneral.dexterPrint("faces!.count: \(faces!.count)")
            return true
        } else {
            DexterGeneral.dexterPrint("No Face")
            return false
        }
    }
    
}
