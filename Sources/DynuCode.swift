import Foundation

public enum DynuCode: String {
    case good = "good"
    case noChange = "nochg"
    case badAuth = "badauth"
    case membersOnly = "!donator"
    case hostnameNotFound = "nohost"
    case numberOfHosts = "numhost"
    case invalidFQDN = "notfqdn"
    case serverError = "servererror"
    case unknown = "unknown"
    case dnsError = "dnserr"
    case suspendUpdates = "911"
    case abuse = "abuse"
    
    public static var allCodes: [DynuCode] {
        return [.good, .noChange, .badAuth, .hostnameNotFound, .membersOnly, .numberOfHosts, .invalidFQDN, .serverError, .dnsError, .suspendUpdates, .abuse, .unknown]
    }
    
    public init(responseString: String) {
        for code in type(of: self).allCodes {
            if responseString.lowercased().hasPrefix(code.rawValue) {
                self = code
                return
            }
        }
        
        self = .unknown
    }
    
    public var httpStatusCode: Int {
        switch self {
        case .good: return 200
        case .noChange: return 204
        case .hostnameNotFound, .numberOfHosts, .invalidFQDN, .unknown: return 400
        case .badAuth: return 401
        case .membersOnly: return 403
        case .abuse: return 429
        case .dnsError, .serverError: return 500
        case .suspendUpdates: return 503
        }
    }
    
    private var localizedDescription: String {
        switch self {
        case .hostnameNotFound: return "Hostname Not Found"
        case .numberOfHosts: return "Too Many Hosts"
        case .invalidFQDN: return "Invalid FQDN"
        case .badAuth, .membersOnly: return "Invalid Credentials"
        case .abuse: return "Abusive Behavior"
        case .dnsError, .serverError: return "Server-Side Error"
        case .suspendUpdates: return "Temporarily Suspend Updates"
        case .unknown: return "Unknown Error"
        default: return ""
        }
    }
    
    private var localizedFailureReason: String {
        switch self {
        case .hostnameNotFound: return "The hostname/username was not found in the system."
        case .numberOfHosts: return "Too many hostnames(more than 20) were specified in the update process."
        case .invalidFQDN: return "The hostname provided was not a valid fully qualified hostname."
        case .badAuth, .membersOnly: return "Failed authentication for the request or the hostname was not found."
        case .abuse: return "Abusive behavior was detected."
        case .dnsError, .serverError: return "An error was encountered on the server side."
        case .suspendUpdates: return "The server may be under scheduled maintenance."
        case .unknown: return "An invalid request with badly formatted parameters was made."
        default: return ""
        }
    }
    
    private var localizedRecoverySuggestion: String {
        switch self {
        case .numberOfHosts: return "Limit the number of hostnames to 20 and try the request again."
        case .invalidFQDN: return "Ensure each provided hostname is a valid FQDN and try the request again."
        case .hostnameNotFound, .badAuth, .membersOnly: return "Check your username and/or hostname and try the request again."
        case .abuse: return "Ensure your account is in good standing and limit your frequency of requests."
        case .dnsError, .serverError: return "Please try the request again."
        case .suspendUpdates: return "Wait 10 minutes and try the request again."
        case .unknown: return "Check all request fields and try the request again."
        default: return ""
        }
    }
    
    public var error: NSError? {
        switch self {
        case .good, .noChange:
            return nil
        default:
            return NSError(domain: "DynuREST", code: httpStatusCode, userInfo: [
                NSLocalizedDescriptionKey : localizedDescription,
                NSLocalizedFailureReasonErrorKey : localizedFailureReason,
                NSLocalizedRecoverySuggestionErrorKey : localizedRecoverySuggestion
                ])
        }
    }
}
