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
    func updateTask(_ task: Task)
}

class TaskPresenter: TaskPresenterProtocol, ObservableObject {
    private let interactor: TaskInteractorProtocol
    weak var view: TaskViewProtocol?

    init(interactor: TaskInteractorProtocol) {
        self.interactor = interactor
    }
    
    func deleteAllTasks() {
        interactor.deleteAllTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.showTasks([])
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    // MARK: Loading tasks
    func loadTasks() {
        view?.showLoading(true)

        interactor.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.view?.showTasks(tasks) // Отправляем данные во View
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription) // Отображаем ошибку
                }
                self?.view?.showLoading(false)
            }
        }
    }

    // Добавление задачи
    func addNewTask(label: String, caption: String) {
        interactor.addTask(label: label, caption: caption) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadTasks() // Обновляем список задач
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    // Удаление задачи
    func deleteTask(withId id: UUID) {
        interactor.deleteTask(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadTasks() // Обновляем список задач
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    // Обновление задачи
    func updateTask(_ task: Task) {
        interactor.updateTask(task) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadTasks() // Обновляем список задач
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
