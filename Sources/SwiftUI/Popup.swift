import SwiftUI

public struct Popup<C: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: C
    
    init(isPresented: Binding<Bool>, content: C) {
        self._isPresented = isPresented
        self.popupContent = content
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            popupContent
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
                .scaleEffect(isPresented ? 1.0 : 0.85)
                .opacity(isPresented ? 1.0 : 0)
                .animation(.easeInOut(duration: 0.1), value: isPresented)
        }
        .animation(.easeInOut(duration: 0.1), value: isPresented)
    }
}

public extension View {
    func popup<C: View>(isPresented: Binding<Bool>,
                        @ViewBuilder content: () -> C) -> some View {
        self
            .modifier(Popup(isPresented: isPresented, content: content()))
    }
}


#Preview {
    struct PopupPreview: View {
        @State private var isPresented: Bool = false
        
        var body: some View {
            VStack {
                Button("팝업") {
                    isPresented.toggle()
                }
                .padding(.top, 40)
                Spacer()
            }
            .popup(isPresented: $isPresented) {
                VStack {
                    Text("팝업")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Button {
                        isPresented.toggle()
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
    return PopupPreview()
}
