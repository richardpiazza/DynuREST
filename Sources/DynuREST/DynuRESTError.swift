import Foundation

public enum DynuRESTError: Error {
    case requestError(any Error)
    case statusCode(Int)
    case response
    case format(String)
}
