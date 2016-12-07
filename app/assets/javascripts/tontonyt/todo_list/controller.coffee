@TodoListController =
  show: ->
    app.todoList.collection.fetch().then ->
      if app.todoList.collection.length > 0
        app.collectionView = new TodoListCollectionView( collection: app.todoList.collection )
        app.homeView.getRegion('todoList').empty()
        app.homeView.getRegion('todoList').show( app.collectionView )
      else
        app.todoList.controller.clean()
  clean: ->
    app.homeView.getRegion('todoList').empty()
    app.homeView.getRegion('todoList').show( new EmptyTodosView() )
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
