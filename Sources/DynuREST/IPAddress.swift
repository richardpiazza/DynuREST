import Foundation

public enum IPAddress: Codable {
    case ipV4(String)
    case ipV6(String)
    
    enum CodingKeys: String, CodingKey {
        case ip
    }
    
    private static let v4Pattern = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    private static let v6Pattern = "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
    
    public static func make(from value: String) -> IPAddress? {
        do {
            let expression = try NSRegularExpression(pattern: Self.v4Pattern)
            if !expression.matches(in: value, range: NSRange(location: 0, length: value.count)).isEmpty {
                return .ipV4(value)
            }
        } catch {
        }
        
        do {
            let expression = try NSRegularExpression(pattern: Self.v6Pattern)
            if !expression.matches(in: value, range: NSRange(location: 0, length: value.count)).isEmpty {
                return .ipV6(value)
            }
        } catch {
        }
        
        return nil
    }
    
    public init?(stringValue value: String) {
        guard let address = Self.make(from: value) else {
            return nil
        }
        
        self = address
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(String.self, forKey: .ip)
        guard let address = Self.make(from: value) else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Invalid IPAddress")
            throw DecodingError.dataCorrupted(context)
        }
        
        self = address
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .ip)
    }
}

extension IPAddress: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ipV4(let address), .ipV6(let address):
            return address
        }
    }
}
