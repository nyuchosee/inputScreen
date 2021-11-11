//
//  ContentView.swift
//  TestProject
//
//  Created by Ru Nue on 07.11.2021.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var children = [Child(name: "Пётр", age: "15"), Child(name: "Иван", age: "11")]
    
    func addChild(_ child: Child) {
        children.append(child)
    }
    
    func removeAll() {
        children.removeAll()
    }
    
    func removeChild(_ child: Child) {
        if let index = children.firstIndex(where: { $0.id == child.id }) {
            children.remove(at: index)
        }
    }
}

struct ContentView: View {
    
    @State private var oldName = ""
    @State private var oldAge = ""
    @EnvironmentObject var viewModel: ViewModel
    @State private var show_modal: Bool = false
    
    var disabled: Bool {
        viewModel.children.count > 4
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                VStack {
                    TextField("Имя", text: $oldName)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                    TextField("Возраст", text:  $oldAge)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                        .keyboardType(.numberPad)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 25)
                HStack {
                    Text("Дети (макс. 5)")
                    Spacer()
                    Button {
                        self.show_modal = true
                    } label: {
                        Label("Добавить ребенка", systemImage: "plus")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .overlay(
                                Capsule().stroke()
                            )
                    }
                    .sheet(isPresented: self.$show_modal) {
                        ModalView()
                    }
                    .disabled(disabled)
                    
                }
                List {
                    ForEach(viewModel.children) { child in
                        ChildView(child: child)
                    }
                }
                .listStyle(PlainListStyle())
                Spacer()
                Button {
                    viewModel.removeAll()
                } label: {
                    Text("Очистить")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 30)
                        .overlay(
                            Capsule().stroke()
                        )
                        .foregroundColor(.red)
                }
            }
            .padding(20)
            .navigationTitle("Личные данные")
            
        }
    }
}

struct ChildView: View {
    var child: Child
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack {
            HStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Имя")
                        Text(child.name)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                    
                }
                Button {
                    viewModel.removeChild(child)
                } label: {
                    Text("Удалить")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)
                
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Возраст")
                    Text("\(child.age)")
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                VStack {
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ModalView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var age = ""
    
    var disabled: Bool {
        name.isEmpty
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Добавление ребёнка")
                .font(.largeTitle)
                .fontWeight(.regular)
            Spacer()
            Text("Введите имя и возраст вашего ребёнка:")
            VStack {
                TextField("Имя", text: $name)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                TextField("Возраст", text: $age)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                    .keyboardType(.numberPad)
            }
            .padding(20)
            Spacer()
        
            Button {
                viewModel.addChild(Child(name: name, age: age))
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Добавить ребенка", systemImage: "plus")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .overlay(
                        Capsule().stroke()
                    )
            }
            .disabled(disabled)
            Spacer()
        }
    }
}

struct Child: Identifiable {
    let id = UUID().uuidString
    var name = ""
    var age = ""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
