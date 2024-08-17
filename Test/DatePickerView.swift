//
//  DatePickerView.swift
//  Test
//
//  Created by Ibrahim Gedami on 17/08/2024.
//

import SwiftUI

struct DatePickerView: View {
    
    var components: DatePickerComponents = [.date, .hourAndMinute]
    @Binding var date: Date
    var formattedString: (Date) -> String
    @State private var viewId = UUID().uuidString
    @FocusState var isActive
    
    var body: some View {
        TextField(viewId, text: .constant(formattedString(date)))
            .focused($isActive)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        isActive = false
                    } label: {
                        Text("Done")
                        
                    }
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
            }
            .overlay {
                AddInputViewToDatePickerView(id: viewId) {
                    DatePicker("", selection: $date, displayedComponents: components)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
            }
            .onTapGesture {
                isActive = true
            }
    }
    
}

struct ContentView: View {
    
    @State var date: Date = .now
    
    var body: some View {
        NavigationStack {
            DatePickerView(date: $date) { selectedDate in
                let date = selectedDate.prettyShortDate
                return date ?? ""
            }
        }
    }
    
}

#Preview {
    ContentView()
}

fileprivate struct AddInputViewToDatePickerView<Content: View>: UIViewRepresentable {
    
    var id: String
    @ViewBuilder var content: Content
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let window = view.window, let textField = window.allSubViews(type: UITextField.self).first(where: { $0.placeholder == id }) {
                let hostView = UIHostingController(rootView: content).view
                hostView?.backgroundColor = .clear
                hostView?.frame.size =  hostView?.intrinsicContentSize ?? .zero
                textField.inputView = hostView
                textField.tintColor = .clear
                textField.reloadInputViews()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

fileprivate extension UIView {
    
    func allSubViews<T: UIView>(type: T.Type) -> [T] {
        var resultViews = subviews.compactMap({ $0 as? T })
        
        for subView in subviews {
            resultViews.append(contentsOf: subView.allSubViews(type: type))
        }
        
        return resultViews
    }
    
}

extension Date {
    
    var prettyShortDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    
}

extension String {
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if let newDate = dateFormatter.date(from: self) {
            return newDate
        } else {
            dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
            if let newDate = dateFormatter.date(from: self) {
                return newDate
            } else {
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                return dateFormatter.date(from: self)
            }
        }
    }
    
}
