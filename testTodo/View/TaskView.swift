//
//  TaskView.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.11.2024.
//

import Foundation
import SwiftUI


struct TaskView: View {
    
    @State private var tasks: [Task] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let presenter: TaskPresenter
    @ObservedObject private var viewModel: TaskViewModel

    init(presenter: TaskPresenter, viewModel: TaskViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
        self.presenter.view = self.viewModel
    }
    

    
    var addBar: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("\(viewModel.tasks.count) задач")
                Spacer()
            }
            
            Button(action: {
                // show add task view
                NavigationLink(destination: AddTaskView(presenter: presenter)) {
                    AddTaskView(presenter: presenter)
                }
            }) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
            }
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color(red: 39/255, green: 39/255, blue: 41/255)) // rgba(39, 39, 41, 1)
    }

    var body: some View {
        NavigationStack {
            VStack (alignment: .center){
                if viewModel.isLoading {
                    ProgressView("Загрузка задач...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.tasks) { task in
                        HStack(alignment: .top) {
                            Image(task.isDone ? "check_mark_fill" : "check_mark")
                                .onTapGesture {
                                    presenter.updateTask(
                                        Task(
                                            id: task.id,
                                            label: task.label,
                                            caption: task.caption,
                                            isDone: !task.isDone,
                                            createDate: task.createDate
                                        )
                                    )
                                }
                            
                            VStack(alignment: .leading) {
                                Text(task.label)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                    .foregroundStyle(task.isDone == true ? .gray : .white)
                                    .strikethrough(task.isDone == true ? true : false)
                                Text(task.caption)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .foregroundStyle(task.isDone == true ? .gray : .white)
                                    .padding(.bottom, 5)
                                Text(task.createDate.formattedDate())
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .onTapGesture {}.onLongPressGesture(minimumDuration: 0.5) {
//                            Menu("Menu", systemImage: "ellipsis") {
//                                Button("Edit", systemImage: "edit") {}
//                                Button("Delete", systemImage: "trash") {}
//                            } primaryAction: {
//                                //
//                            }
                            print("Long press")
                            // here need to add showing view, where realised options for task, like delete, edit
                        }
                    }
                }
                Spacer()
                
                // bar with add task and tasks count
                addBar
            }
            .navigationTitle("Задачи")
            .onAppear {
                viewModel.showLoading(true)
                presenter.loadTasks()
            }
        }
    }
    
    
}
