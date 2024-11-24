//
//  testTodoApp.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import SwiftUI

@main
struct testTodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        // Создаем все нужные зависимости
        let interactor = TaskInteractor()
        let presenter = TaskPresenter(interactor: interactor)
        let viewModel = TaskViewModel(presenter: presenter)
//        let viewLogic = TaskViewModel(presenter: presenter)

        WindowGroup {
            TaskView(presenter: presenter, viewModel: viewModel) // Передаем TaskViewLogic в TaskView
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .foregroundColor(.white) // Белый текст по умолчанию
                .preferredColorScheme(.dark) // Принудительная тёмная тема
        }
    }
}
