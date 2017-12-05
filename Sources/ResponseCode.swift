import Foundation

/// A reprsentation of the status codes that should be returned from the Dynu.com API.
/// Use the init(stringValue:) with the test response to parse the correct response.
public enum ResponseCode: Int, Error, LocalizedError {
    case ok = 200
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case toManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503
    
    public init(stringValue: String) {
        switch stringValue {
        case "good":
            self = .ok
        case "nochg":
            self = .noContent
        case "badauth":
            self = .unauthorized
        case "!donator":
            self = .forbidden
        case "abuse":
            self = .toManyRequests
        case "dnserr", "servererror":
            self = .internalServerError
        case "911":
            self = .serviceUnavailable
        default:
            self = .badRequest
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .ok, .noContent: return ""
        case .unauthorized, .forbidden: return "Failed authentication for the request or the account was forbidden."
        case .toManyRequests: return "The server may be under scheduled maintenance."
        case .internalServerError: return "An error was encountered on the server side."
        case .serviceUnavailable: return "The server may be under scheduled maintenance."
        default: return "An invalid request with badly formatted parameters was made."
        }
    }
}
