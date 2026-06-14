import Foundation

/// Dynu.com API Response Codes
///
/// A representation of the status codes that should be returned from the Dynu.com API.
/// Use the `init(stringValue:)` with the test response to parse the correct response.
public enum ResponseCode: Int, Error {
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
}

// MARK: - LocalizedError

extension ResponseCode: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ok, .noContent: ""
        case .unauthorized, .forbidden: "Failed authentication for the request or the account was forbidden."
        case .toManyRequests: "The server may be under scheduled maintenance."
        case .internalServerError: "An error was encountered on the server side."
        case .serviceUnavailable: "The server may be under scheduled maintenance."
        default: "An invalid request with badly formatted parameters was made."
        }
    }
}

extension ResponseCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ok: "200: OK"
        case .noContent: "204: No Content"
        case .unauthorized: "401: Unauthorized"
        case .forbidden: "403: Forbidden"
        case .toManyRequests: "429: To Many Requests"
        case .internalServerError: "500: Internal Server Error"
        case .serviceUnavailable: "503: Service Unavailable"
        default: "400: Bad Request"
        }
    }
}
