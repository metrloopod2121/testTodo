### В проекте 6 основных слоев:
 
- **Core Data** - осуществляет сохранение, загрузку, изменение данных
	- **TaskDataManager** - createTask, fetchTask, updateTask, deleteTask, saveContext реализуют "прямое" взаимодействие с хранилищем Core Data 
	 
- **Entity** - здесь реализованы все необходимые сущности :
	- Task - основная структура для хранения задачи
	- TodoResponse - структура для парсинга из JSON 
	- Также в проекте есть модель TaskEntity для Core Data, я поместил её на слой Core Data, семантически это будет правильнее, но всё же это сущность, которую можно отнести к понятию Entity
	
- **Interactor** - Здесь реализована вся бизнес-логика для взаимодействия с задачами:
	- fetchTasks - реализует загрузку задач из JSON при первом открытии приложения, затем данные грузятся из Core Data
	- addTask, deleteTask, updateTask, fetchTasksFromAPI, fetchTasksFromCoreData, saveTasksToCoreData - вызывают методы **TaskDataManager** для управления задачами
	 
- **Presenter** - Выступает связующим компонентом между слоями View и Interactor. Получает информацию от Interactor и отправляет сообщения для перерисовки View

- **View** - Отвечает за отрисовку View

- **Router** - Отвечает за все переходы между экранами в приложении 
