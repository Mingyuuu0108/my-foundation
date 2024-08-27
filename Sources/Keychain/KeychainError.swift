import Foundation

public enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}
