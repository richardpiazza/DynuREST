import Foundation

public enum ResponseCode: Int {
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
    
    private var localizedDescription: String {
        switch self {
        case .ok, .noContent: return ""
        case .unauthorized, .forbidden: return "Invalid Credentials"
        case .toManyRequests: return "Temporarily Suspend Updates"
        case .internalServerError: return "Server-Side Error"
        case .serviceUnavailable: return "Temporarily Suspend Updates"
        default: return "Bad Request"
        }
    }
    
    private var localizedFailureReason: String {
        switch self {
        case .ok, .noContent: return ""
        case .unauthorized, .forbidden: return "Failed authentication for the request or the account was forbidden."
        case .toManyRequests: return "The server may be under scheduled maintenance."
        case .internalServerError: return "An error was encountered on the server side."
        case .serviceUnavailable: return "The server may be under scheduled maintenance."
        default: return "An invalid request with badly formatted parameters was made."
        }
    }
    
    private var localizedRecoverySuggestion: String {
        switch self {
        case .ok, .noContent: return ""
        case .unauthorized, .forbidden: return "Check your username and ensure your account is in good standing."
        case .toManyRequests: return "Wait 10 minutes and try the request again."
        case .internalServerError: return "Please try the request again."
        case .serviceUnavailable: return "Wait 10 minutes and try the request again."
        default: return "Check all request fields and try the request again."
        }
    }
    
    public var error: NSError? {
        switch self {
        case .ok, .noContent:
            return nil
        default:
            return NSError(domain: "DynuREST", code: self.rawValue, userInfo: [
                NSLocalizedDescriptionKey : localizedDescription,
                NSLocalizedFailureReasonErrorKey : localizedFailureReason,
                NSLocalizedRecoverySuggestionErrorKey : localizedRecoverySuggestion
                ])
        }
    }
}
