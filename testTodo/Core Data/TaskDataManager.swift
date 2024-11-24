//
//  TaskDataManager.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 24.11.2024.
//

import Foundation
import CoreData

class TaskDataManager {
    static let shared = TaskDataManager()

    private let context = PersistenceController.shared.container.viewContext

    // MARK: - Создание задачи
    func createTask(label: String, caption: String, completion: @escaping (Result<TaskEntity, Error>) -> Void) {
        let newTask = TaskEntity(context: context)
        newTask.id = UUID()
        newTask.label = label
        newTask.caption = caption
        newTask.isDone = false
        newTask.createDate = Date()

        saveContext { result in
            switch result {
            case .success:
                completion(.success(newTask))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Чтение задач
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
    /// Here you can sort tasks in list by creation date
    // request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]

        do {
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Обновление задачи
    func updateTask(task: TaskEntity, newLabel: String, newCaption: String, isDone: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        task.label = newLabel
        task.caption = newCaption
        task.isDone = isDone
        task.createDate = Date()

        saveContext { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Удаление задачи
    func deleteTask(task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        context.delete(task)
        saveContext { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Сохранение контекста
    private func saveContext(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

