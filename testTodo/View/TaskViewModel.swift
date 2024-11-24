//
//  TaskViewModel.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation

protocol TaskViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task])
    func showError(_ message: String)
    func showLoading(_ flag: Bool)
    func setLoading(_ isLoading: Bool)
}

class TaskViewModel: ObservableObject, TaskViewProtocol {
    @Published private(set) var tasks: [Task] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    var presenter: TaskPresenterProtocol

    init(presenter: TaskPresenterProtocol) {
        self.presenter = presenter
    }
    
    func showTasks(_ tasks: [Task]) {
        DispatchQueue.main.async {
            self.tasks = tasks
            self.isLoading = false
        }
    }

    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    func showError(_ message: String) {
        self.errorMessage = message
    }

    func showLoading(_ flag: Bool) {
        self.isLoading = flag
    }
    
    // Новый метод для добавления задачи
    func addTask(_ task: Task) {
        self.tasks.append(task)
    }
}





