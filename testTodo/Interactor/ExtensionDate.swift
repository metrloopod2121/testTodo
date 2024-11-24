//
//  ExtensionDate.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 21.11.2024.
//

import Foundation

extension Date {
    func formattedDate(style: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style
        return formatter.string(from: self)
    }
}


