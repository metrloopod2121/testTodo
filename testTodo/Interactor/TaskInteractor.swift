//
//  TaskInteractor.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation
import CoreData




protocol TaskInteractorProtocol {
    /// Load task list
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    
    /// Add task
    func addTask(label: String, caption: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Delete task by id
    func deleteTask(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Update task
    func updateTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Delete all task
    func deleteAllTasks(completion: @escaping (Result<Void, Error>) -> Void)
}

class TaskInteractor: TaskInteractorProtocol {
    private let taskManager = TaskDataManager.shared
    private var isInitialLoadComplete = false
    
    // MARK: - Task load
    /// - First run app loaded tasks from JSON by use fetchTasksFromAPI()
    /// - After this, all data load from Core Data
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if isInitialLoadComplete {
            // If data is loaded, read from Core Data
            fetchTasksFromCoreData(completion: completion)
        } else {
            fetchTasksFromAPI { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tasks):
                    self.saveTasksToCoreData(tasks: tasks) { saveResult in
                        switch saveResult {
                        case .success:
                            self.isInitialLoadComplete = true
                            self.fetchTasksFromCoreData(completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Add Task
    func addTask(label: String, caption: String, completion: @escaping (Result<Void, Error>) -> Void) {
        taskManager.createTask(label: label, caption: caption) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        taskManager.fetchTasks { result in
            switch result {
            case .success(let entities):
                if let taskToDelete = entities.first(where: { $0.id == id }) {
                    self.taskManager.deleteTask(task: taskToDelete) { deleteResult in
                        switch deleteResult {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "TaskInteractor", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update Task
    /// - use for update anything about task
    func updateTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        taskManager.fetchTasks { result in
            switch result {
            case .success(let entities):
                if let taskToUpdate = entities.first(where: { $0.id == task.id }) {
                    self.taskManager.updateTask(task: taskToUpdate, newLabel: task.label, newCaption: task.caption, isDone: task.isDone) { updateResult in
                        switch updateResult {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "TaskInteractor", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Load tasks from JSON
    private func fetchTasksFromAPI(completion: @escaping (Result<[Task], Error>) -> Void) {
        let urlString = "https://dummyjson.com/todos"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(TodoResponse.self, from: data)
                
                // Return only task's array
                completion(.success(todoResponse.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Load data from Core Data
    private func fetchTasksFromCoreData(completion: @escaping (Result<[Task], Error>) -> Void) {
        taskManager.fetchTasks { result in
            switch result {
            case .success(let entities):
                let tasks = entities.map { entity in
                    Task(
                        id: entity.id,
                        label: entity.label,
                        caption: entity.caption,
                        isDone: entity.isDone,
                        createDate: entity.createDate
                    )
                }
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - save data to Core Data
    private func saveTasksToCoreData(tasks: [Task], completion: @escaping (Result<Void, Error>) -> Void) {
        for task in tasks {
            taskManager.createTask(label: task.label, caption: task.caption) { result in
                if case .failure(let error) = result {
                    completion(.failure(error))
                    return
                }
            }
        }
        completion(.success(()))
    }
    
    // MARK: - Delete all tasks
    func deleteAllTasks(completion: @escaping (Result<Void, Error>) -> Void) {
        taskManager.deleteAllTasks { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

