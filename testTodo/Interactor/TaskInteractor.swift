//
//  TaskInteractor.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation

protocol TaskInteractorProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func addTask(_ task: Task, completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteTask(withId id: UUID, completion: @escaping (Result<Bool, Error>) -> Void)
    func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Bool, Error>) -> Void)
    func updateTask(_ task: Task, completion: @escaping (Result<Bool, Error>) -> Void)
}

class TaskInteractor: TaskInteractorProtocol {
    private(set) var tasks: [Task] = []

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(.success(self.tasks))
        }
    }

    func addTask(_ task: Task, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            self.tasks.append(task)
            completion(.success(true))
        }
    }

    func deleteTask(withId id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            if let index = self.tasks.firstIndex(where: { $0.id == id }) {
                self.tasks.remove(at: index)
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
            }
        }
    }

    func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let index = self.tasks.firstIndex(where: { $0.id == id }) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
                return
            }
            self.tasks[index].isDone.toggle()
            completion(.success(true))
        }
    }

    func updateTask(_ task: Task, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks[index] = task
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task not found"])))
            }
        }
    }
}




