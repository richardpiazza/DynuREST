import Foundation

public enum BundleConfiguration {
    case debug
    case testFlight
    case appStore
    
    public var description: String {
        switch self {
        case .debug: return "Debug"
        case .testFlight: return "TestFlight"
        case .appStore: return "App Store"
        }
    }
}

/// Extension on Bundle that provides first level property access to common bundle items.
/// Also provides methods for determining class names in other modules.
public extension Bundle {
    
    public struct Keys {
        /// CFBundleName
        static let BundleName = kCFBundleNameKey as String
        /// CFBundleDisplayName
        static let BundleDisplayName = "CFBundleDisplayName"
        /// CFBundleExecutable
        static let BundleExecutableName = kCFBundleExecutableKey as String
        /// CFBundleShortVersionString
        static let AppVersion = "CFBundleShortVersionString"
        /// CFBundleVersion
        static let BuildNumber = kCFBundleVersionKey as String
        /// CFBundleIdentifier
        static let BundleIdentifier = kCFBundleIdentifierKey as String
        /// UILaunchStoryboardName
        static let LaunchScreen = "UILaunchStoryboardName"
        /// UIMainStoryboardFile
        static let MainStoryboard = "UIMainStoryboardFile"
    }
    
    public var bundleName: String? {
        return self.object(forInfoDictionaryKey: Keys.BundleName) as? String
    }
    
    public var bundleDisplayName: String? {
        return self.object(forInfoDictionaryKey: Keys.BundleDisplayName) as? String
    }
    
    public var executableName: String? {
        return self.object(forInfoDictionaryKey: Keys.BundleExecutableName) as? String
    }
    
    public var appVersion: String? {
        return self.object(forInfoDictionaryKey: Keys.AppVersion) as? String
    }
    
    public var buildNumber: String? {
        return self.object(forInfoDictionaryKey: Keys.BuildNumber) as? String
    }
    
    public var launchScreenStoryboardName: String? {
        return self.object(forInfoDictionaryKey: Keys.LaunchScreen) as? String
    }
    
    public var mainStoryboardName: String? {
        return self.object(forInfoDictionaryKey: Keys.MainStoryboard) as? String
    }
    
    public var hasSandboxReceipt: Bool {
        return appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
    public var configuration: BundleConfiguration {
        #if targetEnvironment(simulator)
        return .debug
        #else
        return (hasSandboxReceipt) ? .testFlight : .appStore
        #endif
    }
    
    public var dictionary: [String : String] {
        return [
            Keys.BundleName : bundleName ?? "",
            Keys.BundleDisplayName : bundleDisplayName ?? "",
            Keys.BundleExecutableName : executableName ?? "",
            Keys.BundleIdentifier : bundleIdentifier ?? "",
            Keys.AppVersion : appVersion ?? "",
            Keys.BuildNumber : buildNumber ?? "",
            Keys.LaunchScreen : launchScreenStoryboardName ?? "",
            Keys.MainStoryboard : mainStoryboardName ?? "",
            "Configuration" : configuration.description
        ]
    }
    
    public var data: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            Log.error(error)
            return nil
        }
    }
    
    
}

#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
    public extension Bundle {
        /// Attempts to determine the "full" modularized name for a given class.
        /// For example: when using CodeQuickKit as a module, the moduleClass for
        /// the `WebAPI` class would be `CodeQuickKit.WebAPI`.
        public func moduleClass(forClassNamed classNamed: String) -> AnyClass {
            var moduleClass: AnyClass? = NSClassFromString(classNamed)
            if moduleClass != nil && moduleClass != NSNull.self {
                return moduleClass!
            }
            
            if let prefix = bundleDisplayName {
                let underscored = prefix.replacingOccurrences(of: " " , with: "_")
                moduleClass = NSClassFromString("\(underscored).\(classNamed)")
                if moduleClass != nil && moduleClass != NSNull.self {
                    return moduleClass!
                }
            }
            
            if let prefix = bundleName {
                let underscored = prefix.replacingOccurrences(of: " " , with: "_")
                moduleClass = NSClassFromString("\(underscored).\(classNamed)")
                if moduleClass != nil && moduleClass != NSNull.self {
                    return moduleClass!
                }
            }
            
            return NSNull.self
        }
        
        /// Takes the moduleClass for a given class and attempts to singularize it.
        public func singularizedModuleClass(forClassNamed classNamed: String) -> AnyClass {
            var moduleClass: AnyClass? = self.moduleClass(forClassNamed: classNamed)
            if moduleClass != nil && moduleClass != NSNull.self {
                return moduleClass!
            }
            
            let firstRange = classNamed.startIndex..<classNamed.index(classNamed.startIndex, offsetBy: 1)
            let endRange = classNamed.index(classNamed.endIndex, offsetBy: -1)..<classNamed.endIndex
            
            var singular = classNamed
            singular.replaceSubrange(firstRange, with: singular[firstRange].uppercased())
            if singular.lowercased().hasSuffix("s") {
                singular.replaceSubrange(endRange, with: "")
            }
            
            moduleClass = self.moduleClass(forClassNamed: singular)
            if moduleClass != nil && moduleClass != NSNull.self {
                return moduleClass!
            }
            
            return NSNull.self
        }
    }
#endif

#if os(iOS)
    import UIKit
    
    public extension Bundle {
        /// This call potentially throws an execption that cannot be caught.
        public var launchScreenStoryboard: UIStoryboard? {
            guard let name = launchScreenStoryboardName else {
                return nil
            }
            
            return UIStoryboard(name: name, bundle: self)
        }
        
        /// This call potentially throws an execption that cannot be caught.
        public var mainStoryboard: UIStoryboard? {
            guard let name = mainStoryboardName else {
                return nil
            }
            
            return UIStoryboard(name: name, bundle: self)
        }
    }
#endif
