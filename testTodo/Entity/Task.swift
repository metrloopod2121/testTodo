//
//  Task.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation

struct Task: Codable, Identifiable {
    
    var id: UUID
    var label: String
    var caption: String
    var isDone: Bool
    var createDate: Date
    
    
    init(label: String, caption: String = "", isDone: Bool = false, createDate: Date = Date()) {
        self.id = UUID()
        self.label = label
        self.caption = caption
        self.isDone = isDone
        self.createDate = createDate
    }
}
