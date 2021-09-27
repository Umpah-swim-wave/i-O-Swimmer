//
//  UIFont+.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

struct AppFontName {
    static let IBMFlexSansRegular = "IBMPlexSans-Regular"
    static let IBMFlexSansText = "IBMPlexSans-Text"
    static let IBMFlexSansSemiBold = "IBMPlexSans-SemiBold"
    static let IBMFlexSansBold = "IBMPlexSans-Bold"
    static let nexaBold = "Nexa-Bold"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    @objc class func IBMFlexSansRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMFlexSansRegular, size: size)!
    }
    
    @objc class func IBMFlexSansText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMFlexSansText, size: size)!
    }
    
    @objc class func IBMFlexSansSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMFlexSansSemiBold, size: size)!
    }
    
    @objc class func IBMFlexSansBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.IBMFlexSansBold, size: size)!
    }
    
    @objc class func nexaBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.nexaBold, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.IBMFlexSansRegular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.IBMFlexSansBold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.IBMFlexSansText
                default:
                    fontName = AppFontName.IBMFlexSansRegular
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
            let mySystemFontMethod = class_getClassMethod(self, #selector(IBMFlexSansRegular(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(IBMFlexSansBold(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(IBMFlexSansText(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}
