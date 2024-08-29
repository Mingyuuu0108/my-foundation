import SwiftUI

public struct Popup<C: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupDuration: TimeInterval
    let popupContent: C
    
    public init(
        isPresented: Binding<Bool>,
        duration: TimeInterval,
        content: C
    ) {
        self._isPresented = isPresented
        self.popupDuration = duration
        self.popupContent = content
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
                .blur(radius: isPresented ? 6 : 0)
            popupContent
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
                .scaleEffect(isPresented ? 1.0 : 0.85)
                .opacity(isPresented ? 1.0 : 0)
                .animation(.easeInOut(duration: popupDuration), value: isPresented)
        }
        .animation(.easeInOut(duration: popupDuration), value: isPresented)
    }
}

public extension View {
    func popup<C: View>(
        isPresented: Binding<Bool>,
        duration popupDuration: TimeInterval = 0.15,
        @ViewBuilder content: () -> C
    ) -> some View {
        self
            .modifier(Popup(
                isPresented: isPresented,
                duration: popupDuration,
                content: content()
            ))
    }
}

#Preview {
    struct Popup_Preview: View {
        @State private var isPresented1: Bool = false
        @State private var isPresented2: Bool = false
        
        var body: some View {
            VStack {
                Button("Popup (Default duration)") {
                    isPresented1.toggle()
                }
                .padding(.top, 40)
                Button("Popup (0.5 duration)") {
                    isPresented2.toggle()
                }
                Spacer()
            }
            .popup(isPresented: $isPresented1) {
                VStack {
                    Text("Popup 1")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Button {
                        isPresented1.toggle()
                    } label: {
                        Text("dismiss")
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 200, height: 100)
                .background(.blue)
                .cornerRadius(15)
                .padding(10)
            }
            .popup(isPresented: $isPresented2, duration: 0.5) {
                VStack {
                    Text("Popup 2")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Button {
                        isPresented2.toggle()
                    } label: {
                        Text("dismiss")
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 200, height: 100)
                .background(.blue)
                .cornerRadius(15)
                .padding(10)
            }
        }
    }
    return Popup_Preview()
}
