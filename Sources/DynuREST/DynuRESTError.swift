import Foundation

public enum DynuRESTError: Error {
    case requestError(Error)
    case statusCode(Int)
    case response
    case format(String)
}
