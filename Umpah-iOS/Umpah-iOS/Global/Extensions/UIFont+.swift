//
//  UIFont+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

struct AppFontName {
    static let IBMPlexSansText = "IBMPlexSansKR-Text"
    static let IBMPlexSansSemiBold = "IBMPlexSansKR-SemiBold"
    static let IBMPlexSansBold = "IBMPlexSansKR-Bold"
    static let IBMPlexSansRegular = "IBMPlexSansKR"
    static let IBMPlexSansMedium = "IBMPlexSansKR-Medium"
    static let nexaBold = "Nexa Bold"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    @objc class func IBMPlexSansRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMPlexSansRegular, size: size)!
    }
    
    @objc class func IBMPlexSansText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMPlexSansText, size: size)!
    }
    
    @objc class func IBMPlexSansSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMPlexSansSemiBold, size: size)!
    }
    
    @objc class func IBMPlexSansBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMPlexSansBold, size: size)!
    }
    
    @objc class func nexaBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.nexaBold, size: size)!
    }
    
    @objc class func IBMPlexSansMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMPlexSansMedium, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.IBMPlexSansRegular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.IBMPlexSansBold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.IBMPlexSansText
                default:
                    fontName = AppFontName.IBMPlexSansRegular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }

    class func overrideInitialize() {
        if self == UIFont.self {
            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
            let mySystemFontMethod = class_getClassMethod(self, #selector(IBMPlexSansRegular(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(IBMPlexSansBold(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(IBMPlexSansText(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}
