//
//  AddTaskView.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 21.11.2024.
//

import Foundation
import SwiftUI

struct AddTaskView: View {

    @State private var label: String = ""
    @State private var caption: String = ""
    
    private let presenter: TaskPresenter
    var task: Task?

    init(presenter: TaskPresenter, selectedTask: Task?) {
        self.presenter = presenter
        self.task = selectedTask
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            TextField("Название задачи", text: $label)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 30))
                .padding()
            
            HStack {
                Text(Date().formattedDate())
                    .foregroundStyle(.gray)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.leading)
            
            TextEditor(text: $caption)
                .padding(.horizontal, 10)

            Spacer()
        }
        .onDisappear() {
            if var taskToUpdate = task {
                taskToUpdate.label = label
                taskToUpdate.caption = caption
                presenter.updateTask(taskToUpdate)
            } else {
                presenter.addNewTask(label: label, caption: caption)
            }
        }
    }
    
    var body: some View {
        header
            .onAppear {
                if let task = task {
                    label = task.label
                    caption = task.caption
                }
            }
//            .navigationTitle(task != nil ? "Изменение" : "Добавление")
    }
}



