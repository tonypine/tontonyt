@HomeView = Mn.View.extend
  template: JST["home"]
  regions:
    todoList: "#todo-list-region"
  events:
    'keypress #new-todo': "createTodo"
  createTodo: (ev) ->
    if ev.keyCode is 13
      app.trigger 'newTodo', { title: ev.currentTarget.value }
      ev.currentTarget.value = ''

@EmptyTodosView = Mn.View.extend
  template: JST['empty_todo_list']
  className: 'empty-todo'
