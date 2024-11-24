//
//  Task.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation

// Основная структура для задач
struct Task: Codable, Identifiable {
    
    var id: UUID
    var label: String
    var caption: String
    var isDone: Bool
    var createDate: Date
    
    enum CodingKeys: String, CodingKey {
        case label = "todo"
        case caption = "id"
        case id = "userId" // Здесь мы указываем, что поле "id" в JSON будет маппироваться на свойство "id"
        case isDone = "completed"
        case createDate
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Парсим id из id, создаём UUID
        let userId = try container.decode(Int.self, forKey: .id)
        self.id = UUID(uuidString: "\(userId)") ?? UUID()
        self.label = try container.decode(String.self, forKey: .label)
        
        // Парсим остальные значения
//        self.caption = try container.decode(String.self, forKey: .caption)
        self.caption = "Caption"
        self.isDone = try container.decode(Bool.self, forKey: .isDone)
        self.createDate = Date() // Устанавливаем текущую дату
    }

    // Инициализатор для создания вручную
    init(id: UUID = UUID(), label: String, caption: String, isDone: Bool = false, createDate: Date = Date()) {
        self.id = id
        self.label = label
        self.caption = caption
        self.isDone = isDone
        self.createDate = createDate
    }
}
