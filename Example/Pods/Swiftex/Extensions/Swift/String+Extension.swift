//
//  String+Utilites.swift
//  WhatToCook
//
//  Created by Виталий Кузьменко on 27/08/14.
//  Copyright (c) 2014 KuzmenkoFamily. All rights reserved.
//


import UIKit

extension String {

    public var trim: String {
        let charSet = CharacterSet.whitespacesAndNewlines
        return String(format: "%@", self.trimmingCharacters(in: charSet))
    }
    
    public var isEmail: Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    public var isAlphabet: Bool {
        let regEx = "[A-Za-z_]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    public var URLEncode: String {
        let originalString = self
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString!
    }
    
    public var URLValue: URL? {
        var URLString = self
        if URLString.hasPrefix("//") {
            URLString = "http:" + URLString
            if let URL = URL(string: URLString) {
                return URL
            }
        } else if let URL = URL(string: URLString) {
            return URL
        }
        return nil
    }
    
    public var localizeDecimalSeparator: String {
        let nf = NumberFormatter()
        if let separator = nf.decimalSeparator {
            var safeValue = self
            if separator == "," {
                safeValue = self.replacingOccurrences(of: ".", with: ",", options: [], range: nil)
            } else {
                safeValue = self.replacingOccurrences(of: ",", with: ".", options: [], range: nil)
            }
            return safeValue
        }
        return self
    }
    
    public var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = self.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    public var letters: String {
        let set = CharacterSet.letters.inverted
        let letters = self.components(separatedBy: set)
        return letters.joined(separator: "")
    }
    
    public var lettersWithSpace: String {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
        let letters = self.components(separatedBy: set)
        return letters.joined(separator: "")
    }
    
    public var dataValue: Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    public func lastCharacters(count: Int) -> String {
        if count >= self.length {
            return self
        } else {
            return self.substring(from: self.characters.index(self.endIndex, offsetBy: -count))
        }
    }
    
    public var decodeHTMLEntitles: String {
        
        let encodedString = self
        
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        let attributedOptions : [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as Any,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as Any
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            let decodedString = attributedString.string
            return decodedString
        } catch _ {
            return encodedString
        }
    }
    
    public var stringByStrippingHTML: String {
        var string = self
        let charactersToReplace = ["<br>", "<br />", "<br/>", "</p>"]
        
        for charater in charactersToReplace {
            string = string.replacingOccurrences(of: charater, with: "\n", options: [], range: nil)
        }
        
        string = string.replacingOccurrences(of: "</li>", with: ";", options: [], range: nil)
        
        while let range = string.range(of: "<[^>]+>", options: .regularExpression, range: nil, locale: nil) {
            string = string.replacingCharacters(in: range, with: "")
        }
        
        string = string.replacingOccurrences(of: "\n\n", with: "\n", options: [], range: nil).trim
        
        return string
    }
    
    public var range: NSRange {
        return NSRange(location: 0, length: self.utf16.count)
    }
    
    public var stringWithoutHTML: String? {
        do {
            let pattern = "<a\\b.*?<\\/a>"
            let reg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = reg.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
            return result.length > 0 ? result : nil
        } catch _ {
            return self
        }
    }
    
    public var first: String {
        return String(characters.prefix(1))
    }
    
    public var last: String {
        return String(characters.suffix(1))
    }
    
    public var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    public func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)).trim + (trailing ?? "")
        } else {
            return self
        }
    }
    
    public var notificaitonName: NSNotification.Name {
        return NSNotification.Name(rawValue: self)
    }
    
}

// MARK: - Subcript

extension String {
    
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: characters.index(startIndex, offsetBy: r.lowerBound)..<characters.index(startIndex, offsetBy: r.upperBound))
    }
    
}

extension String {
    
    public var length: Int {
        return self.characters.count
    }
    
}

public extension String {
    
    public func enumCase<T: RawRepresentable>() -> T? {
        if let raw = self as? T.RawValue {
            return T(rawValue: raw)
        }
        return nil
    }
    
}

/**
 *  Calculating String Size
 */
extension String {
    
    public func size(font: UIFont) -> CGSize {
        let originalString = self as NSString
        return originalString.size(attributes: [NSFontAttributeName: font])
    }
    
    public func width(font: UIFont) -> CGFloat {
        return size(font: font).width
    }
    
    public func height(width: CGFloat, withFont font: Any) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height) + 1
        
    }
    
}