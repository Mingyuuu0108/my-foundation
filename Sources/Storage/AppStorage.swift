import Foundation

public class AppStorage {
    public static let standard = UserDefaults.standard
    
    public static func get(for key: String) -> String {
        guard let value = standard.string(forKey: key) else {
            return "error"
        }
        return value
    }
    
    public static func set(_ value: String, for key: String) {
        standard.setValue(value, forKey: key)
    }
    
    public static func remove(for key: String) {
        standard.removeObject(forKey: key)
    }
    
    public static func read(for key: String) {
        if let value = standard.string(forKey: key) {
            print("\(key) : \(value)")
        }
    }
    
    public static func readAll() {
        for (key, value) in standard.dictionaryRepresentation() {
            print("\(key) : \(value)")
        }
    }
}
