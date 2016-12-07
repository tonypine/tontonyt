@TodoItemView = Mn.View.extend
  tagName: 'li'
  template: JST['todo_item']
  onDomRefresh: ->
    this.$('input').iCheck
      checkboxClass: 'icheckbox_flat-red',
      radioClass: 'iradio_flat-red'
  modelEvents:
    'sync': 'render'
    'change:completed': 'render'
  events:
    'ifChanged input': 'updateTodo'
    'click .delete': 'deleteTodo'
  updateTodo: (ev) ->
    app.trigger 'updateTodo', { completed: ev.currentTarget.checked }, this.model
  deleteTodo: (ev) ->
    app.trigger 'destroyTodo', this.model

@TodoListCollectionView = Mn.CollectionView.extend
  tagName: 'ul'
  className: 'todo-list'
  childView: TodoItemView
