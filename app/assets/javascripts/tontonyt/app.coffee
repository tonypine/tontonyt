Mn = Marionette

App = Mn.Application.extend
  region: "#app"
  onStart: (options) ->
    this.todoList = {}
    this.todoList.controller = TodoListController
    this.todoList.collection = new TodoListCollection()
    this.trigger('init')

@app = new App()

# EVENTS
app.on 'init', ->
  app.homeView = new HomeView()
  app.showView app.homeView
  app.todoList.controller.show()
app.on 'destroyTodo', (model) ->
  app.todoList.controller.destroy model
app.on 'newTodo', (data) ->
  app.todoList.controller.add data
app.on 'updateTodo', (data, model) ->
  app.todoList.controller.update data, model
