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
    @State private var showContextMenu: Bool = false
    @State private var selectedTask: Task?
    
    @State private var isShareSheetPresented = false
    @State private var shareItems: [Any] = []
    
    @State private var searchText: String = "" // Для строки поиска

    private let presenter: TaskPresenter
    @ObservedObject private var viewModel: TaskViewModel

    init(presenter: TaskPresenter, viewModel: TaskViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
        self.presenter.view = self.viewModel
    }
    
    // Вычисляемый список задач для отображения
    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter {
                $0.label.localizedCaseInsensitiveContains(searchText) ||
                $0.caption.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    
    var addBar: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Text("\(viewModel.tasks.count) задач")
                Spacer()
            }
            
            NavigationLink(destination: AddTaskView(presenter: presenter, selectedTask: nil)) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.yellow)
            }
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color(red: 39/255, green: 39/255, blue: 41/255)) // rgba(39, 39, 41, 1)
    }
    

    // Вынесенный View для элемента задачи
    func taskItem(for task: Task) -> some View {
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
                    .foregroundStyle(task.isDone ? .gray : .white)
                    .strikethrough(task.isDone)
                Text(task.caption)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(task.isDone ? .gray : .white)
                    .padding(.bottom, 5)
                Text(task.createDate.formattedDate())
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .contextMenu {
            Button(action: {
                selectedTask = task
            }) {
                Label("Редактировать", systemImage: "pencil")
            }
            
            Button(action: {
                shareItems = [task.label, task.caption] // Данные для отправки
                isShareSheetPresented = true
            }) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
                presenter.deleteTask(withId: task.id)
            }) {
                Label("Удалить", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
             ShareSheet(items: shareItems)
         }
    }

    var deleteAllTasksButton: some View {
        Button(action: {
            presenter.deleteAllTasks()
        }) {
            Image(systemName: "arrow.up.trash.fill")
                .resizable()
                .frame(width: 24, height: 24) // Задаём размер иконки
                .foregroundColor(.yellow)     // Устанавливаем цвет
        }
        .padding()
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView("Загрузка задач...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(filteredTasks) { task in
                        taskItem(for: task)
                            .listRowInsets(EdgeInsets()) // Убираем отступы
                            .padding(.vertical, 10)
                            .listRowBackground(Color.clear) // Убираем фон строки
                            .onTapGesture {
                                selectedTask = task
                            }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
//                    .background(Color.black) // Фон экрана
                }
                Spacer()
                addBar // bar with add task and tasks count
            }
            .navigationDestination(isPresented: .constant(selectedTask != nil)) {
                if let task = selectedTask {
                    AddTaskView(presenter: presenter, selectedTask: task)
                } else {
                    AddTaskView(presenter: presenter, selectedTask: nil)
                }
            }
            .navigationTitle("Задачи")
            .navigationBarItems(trailing: deleteAllTasksButton)
            .onAppear {
                viewModel.showLoading(true)
                presenter.loadTasks()
            }
        }
    }
}
