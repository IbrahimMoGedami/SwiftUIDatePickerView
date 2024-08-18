import SwiftUI
import UIKit

struct CustomPickerTextField: UIViewRepresentable {
    
    @Binding var text: String
    var options: [String]
    
    class Coordinator: NSObject, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: CustomPickerTextField
        var pickerView: UIPickerView
        
        init(_ parent: CustomPickerTextField) {
            self.parent = parent
            self.pickerView = UIPickerView()
            super.init()
            
            pickerView.delegate = self
            pickerView.dataSource = self
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if let index = parent.options.firstIndex(of: parent.text) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.options.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.options[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.text = parent.options[row]
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        @objc func doneButtonTapped() {
            parent.text = parent.options[pickerView.selectedRow(inComponent: 0)]
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        
        // Create picker and toolbar
        let pickerView = context.coordinator.pickerView
        textField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct ContentView: View {
    @State private var selectedOption: String = "Tap to select"
    private var options: [String] = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        VStack {
            // Display the actual SwiftUI TextField
            TextField("Tap to select", text: $selectedOption)
                .disabled(true) // Disable editing to prevent keyboard from appearing
                .background(
                    CustomPickerTextField(text: $selectedOption, options: options)
                        .frame(width: 0, height: 0) // Hide the UITextField
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
    }
}
