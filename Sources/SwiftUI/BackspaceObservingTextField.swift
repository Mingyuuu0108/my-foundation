import SwiftUI

public struct BackspaceObservingTextField: View {
    let placeHolder: String
    @Binding var text: String
    let action: () -> Void
    
    public init(_ placeHolder: String, text: Binding<String>, action: @escaping () -> Void) {
        self.placeHolder = placeHolder
        self._text = text
        self.action = action
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            if text == " " || text.isEmpty {
                Text(placeHolder)
                    .foregroundStyle(.gray.opacity(0.3))
            }
            UIKitTextField(text: $text) {
                action()
            }
        }
    }
}

public struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    let backspaceAction: () -> Void
    
    public init(text: Binding<String>, backspaceAction: @escaping () -> Void) {
        self._text = text
        self.backspaceAction = backspaceAction
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.placeholder = "텍스트를 입력해주세요"
        textField.delegate = context.coordinator
        return textField
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let textField = uiView as? UITextField else { return }
        if let text = textField.text {
            textField.text = text.isEmpty ? " " : self.text
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UIKitTextField
        
        init(_ parent: UIKitTextField) {
            self.parent = parent
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            if textField.text == " " {
                if let char = currentText.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        parent.backspaceAction()
                        parent.text = " "
                        textField.text = " "
                        return false
                    }
                }
                parent.text = string
                textField.text = string
                return false
            }
            
            if currentText.isEmpty {
                parent.text = " "
                textField.text = " "
                return false
            }
            return true
        }
    }
}

#Preview {
    struct BackspaceObserverTextfield_Preview: View {
        @State var text: String = String()
        
        var body: some View {
            VStack {
                BackspaceObservingTextField("backspace 를 감지합니다.", text: $text) {
                    print("text : backspace")
                }
                .frame(height: 50)
            }
        }
    }
    return BackspaceObserverTextfield_Preview()
}
