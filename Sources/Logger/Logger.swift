import Foundation

public struct Logger {
    private enum LogType: String {
        case DEBUG
        case NETWORK
        case INFO
        case ERROR
    }
    
    private static func log(_ items: Any..., type: LogType) {
        #if DEBUG
        print("[\(type)]\n\(items.map { "\($0)" }.joined(separator: " "))")
        #endif
    }
}

extension Logger {
    public static func debug(_ items: Any...) {
        log(items, type: .DEBUG)
    }
    
    public static func network(_ items: Any...) {
        log(items, type: .NETWORK)
    }
    
    public static func info(_ items: Any...) {
        log(items, type: .INFO)
    }
    
    public static func error(_ items: Any...) {
        log(items, type: .ERROR)
    }
}
