//
//  ArrayExtension.swift
//  GCNFCTestApp
//
//  Created by Tijn Kooijmans on 04/06/15.
//  Copyright (c) 2015 Studio Sophisti. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
//import Google
import SystemConfiguration.CaptiveNetwork

let iOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)

public func ==(lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location && lhs.length == rhs.length
}

extension CLBeacon {
    var key: String { return "\(self.uuid.uuidString.lowercased())_\(self.major)_\(self.minor)" }
}

extension UIStoryboard {
    
    static func viewControllerForMainStoryboardWithOfClass(_ storyboardClass: UIViewController.Type) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: String(describing: storyboardClass))
    }
    
    static func viewControllerForStoryboard(_ name: String, ofClass storyboardClass: UIViewController.Type) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: String(describing: storyboardClass))
    }
}

extension NSManagedObject {
    
    static func insertNewObjectInContext(_ context: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: type(of: self)), into: context)
    }
}

extension String {
    
    func urlQueryEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func urlHostEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func asLicenseplate() -> String {
        //source: https://blog.kenteken.tv/2011/05/06/code-snippets-formatteren-rdw-kenteken/

        enum Sidecode: String, CaseIterable {
            case sc1  = #"^[a-zA-Z]{2}[\d]{2}[\d]{2}$"#        //1 XX-99-99
            case sc2  = #"^[\d]{2}[\d]{2}[a-zA-Z]{2}$"#        //2 99-99-XX
            case sc3  = #"^[\d]{2}[a-zA-Z]{2}[\d]{2}$"#        //3 99-XX-99
            case sc4  = #"^[a-zA-Z]{2}[\d]{2}[a-zA-Z]{2}$"#    //4 XX-99-XX
            case sc5  = #"^[a-zA-Z]{2}[a-zA-Z]{2}[\d]{2}$"#    //5 XX-XX-99
            case sc6  = #"^[\d]{2}[a-zA-Z]{2}[a-zA-Z]{2}$"#    //6 99-XX-XX
            case sc7  = #"^[\d]{2}[a-zA-Z]{3}[\d]{1}$"#        //7 99-XXX-9
            case sc8  = #"^[\d]{1}[a-zA-Z]{3}[\d]{2}$"#        //8 9-XXX-99
            case sc9  = #"^[a-zA-Z]{2}[\d]{3}[a-zA-Z]{1}$"#    //9 XX-999-X
            case sc10 = #"^[a-zA-Z]{1}[\d]{3}[a-zA-Z]{2}$"#    //10 X-999-XX
            case sc11 = #"^[a-zA-Z]{3}[\d]{2}[a-zA-Z]{1}$"#    //11 XXX-99-X
            case sc12 = #"^[a-zA-Z]{1}[\d]{2}[a-zA-Z]{3}$"#    //12 X-99-XXX
            case sc13 = #"^[\d]{1}[a-zA-Z]{2}[\d]{3}$"#        //13 9-XX-999
            case sc14 = #"^[\d]{3}[a-zA-Z]{2}[\d]{1}$"#        //14 999-XX-9
            //BE:
            case sc15 = #"^[a-zA-Z]{3}[\d]{3}$"#              //15 XXX-999
            case sc16 = #"^[\d]{3}[a-zA-Z]{3}$"#              //16 999-XXX
            case sc17 = #"^[\d]{1}[a-zA-Z]{3}[\d]{3}$"#      //17 9-XXX-999
            
            static func forLicenseplate(_ licenceplate: String) -> Sidecode? {
                for code in Sidecode.allCases {
                    if licenceplate.range(of: code.rawValue, options: .regularExpression) != nil {
                        return code
                    }
                }
                return nil
            }
        }
        
        var licenceplate = self.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").uppercased()
        
        switch Sidecode.forLicenseplate(licenceplate) {
        case .sc1?, .sc2?, .sc3?, .sc4?, .sc5?, .sc6?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 4))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 2))
        case .sc7?, .sc9?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 5))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 2))
        case .sc8?, .sc10?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 4))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 1))
        case .sc11?, .sc14?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 5))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 3))
        case .sc12?, .sc13?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 3))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 1))
        case .sc15?, .sc16?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 3))
        case .sc17?:
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 4))
            licenceplate.insert("-", at: licenceplate.index(licenceplate.startIndex, offsetBy: 1))
        case .none:
            break
        }
        
        return licenceplate
    }
}

extension Array {
    
    func indexOf<T:AnyObject>(_ object: T) -> Int? {
        for (index, value) in self.enumerated() {
            if value as AnyObject === object {
                return index as Int
            }
        }
        return nil
    }
    
    mutating func removeObject<T:AnyObject>(_ object: T) {
        for (index, value) in self.enumerated() {
            if value as AnyObject === object {
                self.remove(at: index)
            }
        }
    }
    func containsObject<T:AnyObject>(_ object: T) -> Bool {
        for value in self {
            if value as AnyObject === object {
                return true
            }
        }
        return false
    }
}
extension UINavigationController {
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let vc = self.topViewController {
            return vc.preferredStatusBarStyle
        } else {
            return .default
        }
    }

}

extension UIViewController {
    
    @objc func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension UIView {
    
    func constraintForIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        for constraint: NSLayoutConstraint in self.constraints {
            if constraint.identifier == identifier {
                return constraint
            }
        }
        return nil
    }
}

extension CALayer {
    
    var borderUIColor: UIColor {
        set(newColor) {
            borderColor = newColor.cgColor
        }
        get {
            return UIColor(cgColor: borderColor!)
        }
    }
}

func randomString(_ items: [String]) -> String {
    return items[Int(arc4random()) % items.count]
}

func clearTempDirectory() {
    let tmpDirectory: [AnyObject]? = try! FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()) as [AnyObject]?
    for file in tmpDirectory! {
        _ = try? FileManager.default.removeItem(atPath: "\(NSTemporaryDirectory())\(file)")
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func hexString(_ byteArray: [UInt8]) -> String {
    // Here we convert the Numberical values to Hex Strings
    var hexBits = "" as String
    for value in byteArray {
        hexBits += NSString(format:"%2X", value) as String
    }
    
    let hexBytes = hexBits.replacingOccurrences(of: "\u{0020}", with: "0", options: NSString.CompareOptions.caseInsensitive)
    
    return hexBytes.lowercased()
}

func UIColorFromHex(_ rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

func UIColorToInt(_ color: UIColor) -> Int32 {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    var color = Int(r * 255) << 16
    color |= Int(g * 255) << 8
    color |= Int(b * 255)
    return Int32(color)
}

func UIImageWithColor(_ color: UIColor) -> UIImage {
    let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

func trackScreen(_ name: String) {
    //Tracker.sharedInstance.trackScreen(name)
}

func trackEvent(_ action: String, label: String = "", value: Int = 0) {
    //Tracker.sharedInstance.trackEvent(action, label: label, value: NSNumber(integerLiteral: value))
}

func loc(_ str: String) -> String {
    return NSLocalizedString(str, comment: str)
}

func isValidEmail(_ testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func getSSID() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                break
            }
        }
    }
    return ssid
}

func openUrl(_ url: URL) {
    if #available(iOS 10.0, *){
        UIApplication.shared.open(url, completionHandler: nil)
    } else{
        UIApplication.shared.openURL(url)
    }
}
extension UserDefaults {
    
    func set(location:CLLocation, forKey key: String){
        let locationLat = NSNumber(value:location.coordinate.latitude)
        let locationLon = NSNumber(value:location.coordinate.longitude)
        self.set(["lat": locationLat, "lon": locationLon], forKey:key)
    }
    
    func location(forKey key: String) -> CLLocation?
    {
        if let locationDictionary = self.object(forKey: key) as? Dictionary<String,NSNumber> {
            let locationLat = locationDictionary["lat"]!.doubleValue
            let locationLon = locationDictionary["lon"]!.doubleValue
            return CLLocation(latitude: locationLat, longitude: locationLon)
        }
        return nil
    }
}
