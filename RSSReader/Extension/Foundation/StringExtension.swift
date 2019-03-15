//
//  StringExtension.swift
//  JayPal
//
//  Created by yang on 2018/7/4.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension String {
    
    /// SwifterSwift: Array of characters of a string.
    public var charactersArray: [Character] {
        return Array(self)
    }
    
    /// SwifterSwift: First character of string (if applicable).
    public var firstCharacter: String? {
        guard let first = first else { return nil }
        return String(first)
    }
    
    public var lastCharacter: String? {
        guard let last = last else { return nil }
        return String(last)
    }
    
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    public var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    public var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    
    public var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    
    public var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    public var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "1", "yes":
            return true
        case "false", "0", "no":
            return false
        default:
            return nil
        }
    }
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    public var isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: Locale.preferredLanguages.first ?? "en")
        return misspelledRange.location == NSNotFound
    }
    
    public var localized: String {
        let localizationText = NSLocalizedString(self, comment: "")
        guard !localizationText.isEmpty else {
            return self
        }
        return localizationText
    }
    
}

// MARK: - Methods
public extension String {
    
   public func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    
    public func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
    public func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    public func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    public func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.0
        return mostCommon
    }
    
    public func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    public func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    
    public subscript(safe i: Int) -> Character? {
        guard i >= 0 && i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
    
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    public func copyToPasteboard() {
        UIPasteboard.general.string = self
    }
    
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    public func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    
    public func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    public func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    public func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    
    public func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
    
    // 时间戳转日期
    public func convertToDate(formatString: String) -> String {
        let timeInterval: TimeInterval = self.count > 10 ? Double(self)!/1000.0 : TimeInterval(self)!
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.string(from: date)
    }
    
}

// MARK: - Initializers
public extension String {
    
    public init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    
    public init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }
    
}

// MARK: - NSAttributedString
public extension String {
    
    public var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    public var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    public var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    public var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    public func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
    // 设置特定字符样式
    public func setText(text: String, textColor: UIColor, textFont: UIFont) -> NSAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let newString: NSString = NSString(string: self)
        let range: NSRange = newString.range(of: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : textFont], range: range)
        return attributedString
    }
    
}

// MARK: - Bounding Rect
public extension String {
    
    /// 计算字符串的大小，根据限定的高或者宽度，计算另一项的值
    public func widthWith(height: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        return self.sizeWithFont(font: font, limitSize: size).width
    }
    
    public func heightWith(width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.sizeWithFont(font: font, limitSize: size).height
    }
    
    public func sizeWithFont(font: UIFont, limitSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let rect = self.boundingRect(with: limitSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.size
    }
    
}

// MARK: - 编码解码
public extension String {
    
    // URL 编码
    public var urlEncode: String? {
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
    // URL 解码
    public var urlDecode: String? {
        return self.removingPercentEncoding
    }
    
    // Base64 编码
    public var base64Encode: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    // Base64解码
    public var base64Decode: String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
}

// MARK: - RegEx 正则
public extension String {
    
    // 字符串是否是邮箱
    public var isEmail: Bool {
        return regexMatch("\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*")
    }
    
    // 是否电话号码
    public var isPhone: Bool {
        return regexMatch("^(([+])\\d{1,4})*(\\d{3,4})*\\d{7,8}(\\d{1,4})*$")
    }
    
    // 是否手机号码
    public var isMobile: Bool {
        return regexMatch("^(([+])\\d{1,4})*1[0-9][0-9]\\d{8}$")
    }
    
    // 是否电话或者手机
    public var isPhoneOrMobile: Bool {
        return isPhone || isMobile
    }
    
    // 是否匹配正则表达式
    public func regexMatch(_ regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    // 是否整数
    public var isInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    // 是否小数
    public var isFloat: Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Float = 0.0
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    
    // 是否合法数字
    public var isLegalDigit: Bool {
        return isInt || isFloat
    }
    
}

// MARK: - 拼音部分
public extension String {
    
    /// 拼音的类型
    public enum PinyinType {
        case normal         // 默认类型，不带声调
        case withTone       // 带声调的拼音
        case firstLetter    // 拼音首字母
    }
    
    public func chineseToPinYin(_ type: PinyinType = .normal) -> String {
        switch type {
        case .normal:
            return normalPinyin()
        case .withTone:
            return pinyinWithTone()
        case .firstLetter:
            return pinyinFirstLetter()
        }
    }
    
    private func normalPinyin() -> String {
        let nameRef = CFStringCreateMutableCopy(nil, 0, self as CFString?)
        CFStringTransform(nameRef, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(nameRef, nil, kCFStringTransformStripDiacritics, false)
        return nameRef! as String
    }
    
    private func pinyinWithTone() -> String {
        let nameRef = CFStringCreateMutableCopy(nil, 0, self as CFString?)
        CFStringTransform(nameRef, nil, kCFStringTransformMandarinLatin, false)
        return nameRef! as String
    }
    
    private func pinyinFirstLetter() -> String {
        let pinyinString = chineseToPinYin() as NSString
        return pinyinString.substring(to: 1)
    }
    
}
