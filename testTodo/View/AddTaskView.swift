//
//  AddTaskView.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 21.11.2024.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    
    

    @Environment(\.dismiss) var dismiss // Управление закрытием экрана
    
    @State private var label: String = ""
    @State private var caption: String = ""
    
    private let presenter: TaskPresenter

    init(presenter: TaskPresenter) {
        self.presenter = presenter
    }
    
    var header: some View {
        VStack {
            TextField("Название задачи", text: $label)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 30))
                .padding()
            
            HStack {
                Text(Date().formattedDate())
                    .foregroundStyle(.gray)
                    .font(.system(.caption))
                Spacer()
            }
            .padding(.leading)
            
            TextEditor(text: $caption)
                .frame(height: 100) // Ограничиваем высоту
                .padding()
                .padding(.horizontal) // Добавляем отступы по бокам

            Spacer()
        }
        .onDisappear() {
            presenter.addNewTask(label: label, caption: caption)
        }
    }
    
    var body: some View {
        header
    }
}


#Preview {
    var interactor = TaskInteractor()
    var presenter = TaskPresenter(interactor: interactor)
    AddTaskView(presenter: presenter)
}
