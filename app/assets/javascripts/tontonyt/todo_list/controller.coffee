@TodoListController =
  show: ->
    if app.todoList.collection.length > 0
      app.homeView.getRegion('todoList').show( app.collectionView )
    else
      app.todoList.controller.clean()
  clean: ->
    app.homeView.getRegion('todoList').show( new EmptyTodosView(), { preventDestroy: true } )
  add: (data) ->
    newTodo = new TodoItemModel data
    if newTodo.save()
      app.todoList.collection.add newTodo
      if app.todoList.collection.length is 1
        app.todoList.controller.show()
  update: (data, model) ->
    model.save data
  destroy: (model) ->
    model.destroy()
    if app.todoList.collection.length is 0
      app.todoList.controller.clean()
