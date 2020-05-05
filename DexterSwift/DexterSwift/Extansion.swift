//
//  Extansion.swift
//  DexterSwift
//
//  Created by ETC0018 on 02/05/2020.
//  Copyright © 2020 xenovector. All rights reserved.
//

import Foundation
import UIKit
//import CommonCrypto

public class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) {
            return
        }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}

public extension String {
    func hexadecimalData() -> Data? {
        var data = Data(capacity: self.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
     }
    
    func printBase64FromSHA1HexString() {
        var hexString = self
        hexString.removeAll(where: {$0 == ":"})
        General.dexterPrint("hexString: \(hexString)")
        if let data = hexString.hexadecimalData() {
            let base64 = data.base64EncodedString()
            General.dexterPrint("base64: \(base64),\ncharacters count: \(base64.count)")
        } else {
            General.dexterPrint("base64: Failed")
        }
    }
    
    func szVersionIsBigger(then providedVersion: String) -> Bool {
        return self.compare(providedVersion, options: .numeric) == .orderedDescending
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    func isEmpty() -> Bool {
        let sz = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return sz == ""
    }
    
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
    
    var data: Data? {
        return self.data(using: .utf8)
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    /*func localized() -> String {
        let lang = General.shared.appLang ?? "en"
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }*/
    
    func localized(_ lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    /**
     This function format string for %s usage.
     - Parameter str: The value to replace %s
     */
    func format(for str: String) -> String {
        return String(format: self.replacingOccurrences(of: "%s", with: "%@"), str)
    }
    
    func format(sz1: String, sz2: String) -> String {
        return String(format: self.replacingOccurrences(of: "%s", with: "%@"), sz1, sz2)
    }
    
    func format(for num: Int) -> String {
        return String(format: self, num)
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func removeHtmlCode(remove_nbsp: Bool = true) -> String {
        let sz = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        return remove_nbsp ? sz.replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression) : sz
    }
}

public extension Int {
    func toString() -> String {
        return "\(self)"
    }
    
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}

public extension Double {
    func decimalTo(_ count: Int) -> String {
        return String(format: "%.\(count)f", self)
    }
}

public extension Data {
    var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            General.dexterPrint("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

public extension Date {
    func toStringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let stringFromDate = dateFormatter.string(from: self)
        return stringFromDate
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(szHex: String, alpha: CGFloat = 1.0) {
        let value = szHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var hex = UInt64()
        Scanner(string: value).scanHexInt64(&hex)
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hex:Int, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        return UIImage.init(cgImage: cgImage)
    }
    
    static func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        //calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed
        let green = (toGreen - fromGreen) * withPercentage + fromGreen
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public extension UIView {
    func fade(hide: Bool, _ duration: TimeInterval?, completion: ((_ finished: Bool) -> Void)?) {
        UIView.animate(withDuration: duration ?? 1.0, delay: 0, options: .showHideTransitionViews, animations: {
            self.alpha = hide ? 0.0 : 1.0
        }, completion: completion)
    }
    
    func blink(timeInterval: TimeInterval = 0.5, alphaRate: CGFloat = 0.25) {
        self.alpha = alphaRate
        UIView.animate(withDuration: timeInterval, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse, .allowUserInteraction], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func animatedZoomRepeatly(scaleRate: CGFloat = 1.2) {
        self.transform = CGAffineTransform.identity
        let options:  UIView.AnimationOptions = [.curveEaseIn, .repeat, .autoreverse, .allowUserInteraction]
        UIView.animate(withDuration: 0.4, delay: 0.0, options: options, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: scaleRate, y: scaleRate)
        }, completion: nil)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addDebugBorder(color: UIColor = .blue) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func getSelectedTextField() -> UITextField? {
        let totalTextFields = getTextFieldsInView(view: self)
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        return nil
    }
    
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        var totalTextFields = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        return totalTextFields
    }
    var frameSize: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get { return frame.size }
    }
    
    var frameX: CGFloat {
        set
        {
            self.frame = CGRect(x:newValue,
                                y:self.frame.origin.y,
                                width:self.frame.size.width,
                                height:self.frame.size.height)
        }
        get { return self.frame.origin.x }
    }
    
    var frameY: CGFloat {
        set
        {
            self.frame = CGRect(x:self.frame.origin.x,
                                y:newValue,
                                width:self.frame.size.width,
                                height:self.frame.size.height)
        }
        get { return self.frame.origin.y }
    }
    
    var frameBottom: CGFloat {
        set
        {
            self.frame = CGRect(x:self.frame.origin.x,
                                y:newValue - self.frame.size.height,
                                width:self.frame.size.width,
                                height:self.frame.size.height);
        }
        get { return self.frame.origin.y + self.frame.size.height }
    }
    
    var frameHeight: CGFloat {
        set
        {
            self.frame = CGRect(x:self.frame.origin.x,
                                y:self.frame.origin.y,
                                width:self.frame.size.width,
                                height:newValue)
        }
        get { return self.frame.size.height }
    }
    
    var frameWidth: CGFloat {
        set
        {
            self.frame = CGRect(x:self.frame.origin.x,
                                y:self.frame.origin.y,
                                width:newValue,
                                height:self.frame.size.height)
        }
        get { return self.frame.size.width }
    }
    
    enum LINE_POSITION {
        case TOP
        case BOTTOM
    }
    
    func addLineTo(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
    
    func applyShadow(scale: Bool = true, radius: CGFloat = 3, shadowColor: UIColor = .black) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -radius/2, height: radius/2)
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setBlurBackground(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        DispatchQueue.main.async {
            self.addSubview(blurEffectView)
            self.sendSubviewToBack(blurEffectView)
        }
    }
    
}


public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        DispatchQueue.main.async {
            self.view.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setBlurBackground(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        DispatchQueue.main.async {
            self.view.addSubview(blurEffectView)
            self.view.sendSubviewToBack(blurEffectView)
        }
    }
    
    enum LINE_POSITION {
        case TOP
        case BOTTOM
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}

public extension UIImage {
    func resizeTo(length: CGFloat, quality: CGFloat) -> UIImage {
        let imageData = self.jpegData(compressionQuality: quality)
        let imageJPEG = UIImage(data: imageData!)!
        var ratio = CGFloat()
        if self.size.height > self.size.width {
            ratio = self.size.height / length
            return resizeImage(image: imageJPEG, newSize: (CGSize(width: self.size.width/ratio, height: length)))
        } else {
            ratio = self.size.width / length
            return resizeImage(image: imageJPEG, newSize: (CGSize(width: length, height: self.size.height/ratio)))
        }
    }
    
    private func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        guard image.size != newSize else {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        /*if newImage == nil {
            return UIImage()
        }*/
        return newImage ?? UIImage()
    }
    
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}

public extension UITextField {
    func placeHolderWithColor(_ text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

public extension UITextView {
    func setFontSize(size: CGFloat) {
        self.font = UIFont(name: self.font!.fontName, size: size)
    }
}

public extension UITableView {
    func scrollToBottom(_ itemCount: Int, animated: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: itemCount-1, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
            //self.layoutIfNeeded()
        }
    }
}

public extension UICollectionView {
    func scrollToBottom(_ itemCount: Int, animated: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: itemCount-1, section: 0)
            self.scrollToItem(at: indexPath, at: .top, animated: animated)
            //self.layoutIfNeeded()
        }
    }
}

public extension Notification.Name {
    static let AudioPlayerDidFinishPlayingAudioFile = Notification.Name("AudioPlayerDidFinishPlayingAudioFile")
}

public extension UIDevice {
    
    var hasNotch: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    func getFreeSize() -> Double {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                let size = freeSize.int64Value
                return Double(size/1000/1000)/1000
            }
        }else{
            General.dexterPrint("Error Obtaining System Memory Info:")
        }
        return 0
    }
    
    func getTotalSize() -> Double {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemSize] as? NSNumber {
                let size = freeSize.int64Value
                return Double(size/1000/1000)/1000
            }
        }else{
            General.dexterPrint("Error Obtaining System Memory Info:")
        }
        return 0
    }
    
    static let deviceYear: String = {
        let deviceModal = UIDevice.model_Name
        
        func getYearOfRelease(szModal: String) -> String { //dd-MM-yyyy
            switch szModal {
            case "iPhone 4":                        return "21-06-2010"
            case "iPhone 4s":                       return "14-10-2011"
            case "iPhone 5":                        return "21-09-2012"
            case "iPhone 5c":                       return "20-09-2013"
            case "iPhone 5s":                       return "20-09-2013"
            case "iPhone 6":                        return "19-09-2014"
            case "iPhone 6 Plus":                   return "19-09-2014"
            case "iPhone 6s":                       return "25-09-2015"
            case "iPhone 6s Plus":                  return "25-09-2015"
            case "iPhone SE":                       return "31-03-2016"
            case "iPhone 7":                        return "16-09-2016"
            case "iPhone 7 Plus":                   return "16-09-2016"
            case "iPhone 8":                        return "22-09-2017"
            case "iPhone 8 Plus":                   return "22-09-2017"
            case "iPhone X":                        return "03-11-2017"
            case "iPhone XS":                       return "21-09-2018"
            case "iPhone XS Max":                   return "21-09-2018"
            case "iPhone XR":                       return "26-10-2018"
            case "iPhone 11":                       return "20-09-2019"
            case "iPhone 11 Pro":                   return "20-09-2019"
            case "iPhone 11 Pro Max":               return "20-09-2019"
            case "iPad 2":                          return "11-03-2011"
            case "iPad (3rd Generation)":           return "16-03-2012"
            case "iPad (4th Generation)":           return "12-11-2012"
            case "iPad (5th Generation)":           return "24-03-2017"
            case "iPad (6th Generation)":           return "27-03-2018"
            case "iPad (7th Generation)":           return "30-09-2019"
            case "iPad Air":                        return "01-11-2013"
            case "iPad Air 2":                      return "22-10-2014"
            case "iPad Air (3rd Generation)":       return "18-03-2019"
            case "iPad Mini 2":                     return "12-11-2013"
            case "iPad Mini 3":                     return "22-10-2014"
            case "iPad Mini 4":                     return "09-09-2015"
            case "iPad mini (5th Generation)":      return "18-03-2019"
            default: return ""
            }
        }
        
        return getYearOfRelease(szModal: deviceModal)
    }()
    
    static let batteryCapacity: Int = {
        let deviceModal = UIDevice.model_Name
        
        func getBatteryCapacity(szModal: String) -> Int {
            switch szModal {
            case "iPhone 4":                        return 1420
            case "iPhone 4s":                       return 1432
            case "iPhone 5":                        return 1440
            case "iPhone 5c":                       return 1507
            case "iPhone 5s":                       return 1570
            case "iPhone 6":                        return 1810
            case "iPhone 6 Plus":                   return 2915
            case "iPhone 6s":                       return 1715
            case "iPhone 6s Plus":                  return 2750
            case "iPhone SE":                       return 1624
            case "iPhone 7":                        return 1960
            case "iPhone 7 Plus":                   return 2900
            case "iPhone 8":                        return 1821
            case "iPhone 8 Plus":                   return 2675
            case "iPhone X":                        return 2716
            case "iPhone XS":                       return 2658
            case "iPhone XS Max":                   return 3174
            case "iPhone XR":                       return 2942
            case "iPhone 11":                       return 3110
            case "iPhone 11 Pro":                   return 3046
            case "iPhone 11 Pro Max":               return 3969
            case "iPad 2":                          return 6930
            case "iPad (3rd Generation)":           return 11560
            case "iPad (4th Generation)":           return 11560
            case "iPad (5th Generation)":           return 8827
            case "iPad (6th Generation)":           return 8827
            case "iPad (7th Generation)":           return 8827
            case "iPad Air":                        return 8820
            case "iPad Air 2":                      return 7340
            case "iPad Air (3rd Generation)":       return 8134
            case "iPad Mini 2":                     return 6450
            case "iPad Mini 3":                     return 6470
            case "iPad Mini 4":                     return 5124
            case "iPad mini (5th Generation)":      return 5124
            default: return 0
            }
        }
        
        return getBatteryCapacity(szModal: deviceModal)
    }()
    
    static let model_Name: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        General.dexterPrint("\nUIDevice.model_Name: \(identifier)")
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPod9,1":                                 return "iPod Touch 7"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd Generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th Generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th Generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th Generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th Generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd Generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th Generation)"
            case "iPhone12,8":                              return "iPhone SE (2nd Generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd Generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd Generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
    
}
