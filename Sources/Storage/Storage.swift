import Foundation

public class Storage {
    public static let standard = UserDefaults.standard
    
    public static func get(for key: String) throws -> String {
        guard let value = standard.string(forKey: key) else {
            throw StorageError.valueNotFound
        }
        return value
    }
    
    public static func set(_ value: String, for key: String) {
        standard.setValue(value, forKey: key)
    }
    
    public static func remove(for key: String) {
        standard.removeObject(forKey: key)
    }
    
    public static func readAll() {
        for (key, value) in standard.dictionaryRepresentation() {
            print("\(key) : \(value)")
        }
    }
}
