import Foundation

public class Keychain {
    private static func keychainQuery(_ key: String, _ service: String?) -> [CFString: Any] {
        var query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        if let service = service {
            query[kSecAttrService] = service
        }
        return query
    }
    
    public static func get(for key: String, service: String? = nil) throws -> String {
        var query = keychainQuery(key, service)
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.unhandledError(status: status)
        }
        return value
    }
    
    public static func set(_ value: String, for key: String, service: String? = nil) throws {
        let encodedData = value.data(using: String.Encoding.utf8)!
        var query = keychainQuery(key, service)
        query[kSecValueData] = encodedData
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    public static func remove(for key: String, service: String? = nil) { }
}
