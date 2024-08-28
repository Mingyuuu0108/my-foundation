import SwiftUI

public struct MarqueeText: View {
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text("\(text)")
    }
}


#Preview {
    MarqueeText("This is a marquee label")
        .background(.blue)
}
