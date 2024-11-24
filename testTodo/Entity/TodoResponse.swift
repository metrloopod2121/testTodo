//
//  TodoResponse.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 24.11.2024.
//

import Foundation

// Структура для парсинга JSON, в поле todos будут храниться все задачи
struct TodoResponse: Codable {
    var todos: [Task]
    var total: Int
    var skip: Int
    var limit: Int
}
