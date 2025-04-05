//
//  ContentView.swift
//  s25-bootcamp-todoey2.0
//
//  Created by Ethan Tran on 3/24/25.

import SwiftUI

struct Todo: Identifiable {
    var id = UUID()
    var item: String
    var isDone: Bool
}

struct TodoRowView: View {
    @Binding var todo: Todo
    var accentColor: Color
    
    var body: some View {
        HStack {
            Button {
                todo.isDone.toggle()
            } label: {
                Circle()
                    .stroke(accentColor, lineWidth: 2)
                    .background(
                        Circle().fill(todo.isDone ? accentColor : Color.clear)
                    )
                    .frame(width: 22, height: 22)
            }
            
            TextField("", text: $todo.item)
                .foregroundColor(todo.isDone ? .gray : .white)
                .strikethrough(todo.isDone)
                .font(.system(size: 22))
        }
    }
}


struct InfoView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var accentColor: Color
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .cyan, .white]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "list.bullet")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    )
                    .padding(.top)
                
                TextField("Title", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Text("Choose a color")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            accentColor = color
                        } label: {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: accentColor == color ? 3 : 0)
                                )
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("List Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { isPresented = false }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView: View {
    @State private var todos = [Todo(item: "Project 4", isDone: false)]
    @State private var newTodoItem = ""
    @State private var showingAddTodo = false
    @State private var showingInfoView = false
    @State private var listTitle = "Todoey"
    @State private var accentColor: Color = .yellow
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    List {
                        ForEach($todos) { $todo in
                            TodoRowView(todo: $todo, accentColor: accentColor)
                                .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteTodo)
                    }
                    .listStyle(PlainListStyle())
                    
                    Button {
                        showingAddTodo = true
                    } label: {
                        HStack {
                            Circle()
                                .fill(accentColor)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("+")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                )
                            
                            Text("New Reminder")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(accentColor)
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(listTitle)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(accentColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingInfoView = true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(accentColor)
                    }
                }
            }
            .alert("Add New Todo", isPresented: $showingAddTodo) {
                TextField("New reminder", text: $newTodoItem)
                Button("Cancel", role: .cancel) { newTodoItem = "" }
                Button("Add") {
                    if !newTodoItem.isEmpty {
                        todos.append(Todo(item: newTodoItem, isDone: false))
                        newTodoItem = ""
                    }
                }
            }
            .sheet(isPresented: $showingInfoView) {
                InfoView(isPresented: $showingInfoView, title: $listTitle, accentColor: $accentColor)
            }
        }
        .preferredColorScheme(.dark)
        .accentColor(accentColor)
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
