//
//  TaskView.swift
//  testTodo
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 18.11.2024.
//

import Foundation
import SwiftUI

protocol TaskViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task])
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}


final class TaskView: TaskViewProtocol {
    
    @State private var tasks: [Task] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var presenter: TaskPresenterProtocol
    
    init(presenter: TaskPresenterProtocol) {
        self.presenter = presenter
    }

       // Реализация методов протокола для обновления UI
       func showTasks(_ tasks: [Task]) {
           self.tasks = tasks
       }
       
       func showError(_ message: String) {
           self.errorMessage = message
       }
       
       func showLoadingIndicator() {
           self.isLoading = true
       }
       
       func hideLoadingIndicator() {
           self.isLoading = false
       }
   }
    
    
