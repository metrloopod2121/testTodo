//
//  TaskPresenter.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation

protocol TaskPresenterProtocol {
    func loadTasks()
    func addNewTask(label: String, caption: String)
    func deleteTask(withId id: UUID)
    func toggleTaskStatus(withId id: UUID)
}

class TaskPresenter: TaskPresenterProtocol {
    private let interactor: TaskInteractorProtocol
    weak var view: TaskViewProtocol?

    init(interactor: TaskInteractorProtocol) {
        self.interactor = interactor
    }

    func loadTasks() {
        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.view?.showTasks(tasks)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func addNewTask(label: String, caption: String) {
        let newTask = Task(label: label, caption: caption)
        interactor.addTask(newTask) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        self?.loadTasks()
                    }
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func deleteTask(withId id: UUID) {
        interactor.deleteTask(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        self?.loadTasks()
                    }
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func toggleTaskStatus(withId id: UUID) {
        interactor.toggleTaskStatus(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        self?.loadTasks()
                    }
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
