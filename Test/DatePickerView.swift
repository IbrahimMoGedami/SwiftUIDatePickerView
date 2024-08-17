import SwiftUI

struct ContentView: View {
    @State var selectedIndex: Int? = nil
    let options: [String] = ["Option1", "Option2"]

    var body: some View {
       PickerField("Select an option", data: self.options, selectionIndex: self.$selectedIndex)
    }
}

struct PickerField: UIViewRepresentable {
    // MARK: - Public properties
    @Binding var selectionIndex: Int?

    // MARK: - Initializers
    init<S>(_ title: S, data: [String], selectionIndex: Binding<Int?>) where S: StringProtocol {
        self.placeholder = String(title)
        self.data = data
        self._selectionIndex = selectionIndex

        textField = PickerTextField(data: data, selectionIndex: selectionIndex)
    }

    // MARK: - Public methods
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let index = selectionIndex {
            uiView.text = data[index]
        } else {
            uiView.text = ""
        }
    }

    // MARK: - Private properties
    private var placeholder: String
    private var data: [String]
    private let textField: PickerTextField
}

class PickerTextField: UITextField {
    // MARK: - Public properties
    var data: [String]
    @Binding var selectionIndex: Int?

    // MARK: - Initializers
    init(data: [String], selectionIndex: Binding<Int?>) {
        self.data = data
        self._selectionIndex = selectionIndex
        super.init(frame: .zero)
        
        setupPickerView()
        setupToolbar()
        customizeAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private func setupPickerView() {
        self.inputView = pickerView
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }

    private func customizeAppearance() {
        self.tintColor = .clear
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 16)
    }

    // MARK: - Private methods
    @objc
    private func donePressed() {
        self.selectionIndex = self.pickerView.selectedRow(inComponent: 0)
        self.endEditing(true)
    }
    
    @objc
    private func cancelPressed() {
        self.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate extension
extension PickerTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
    }
}
