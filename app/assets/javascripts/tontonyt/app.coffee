Mn = Marionette
# _.templateSettings = {
#   interpolate: /\{\{(.+?)\}\}/g
# };

App = Mn.Application.extend
  region: "#app"
  onStart: (options) ->
    this.controller = AppController
    TonTonYt.collection = new TodoListCollection()
    this.trigger('todoShow')

window.TonTonYt = new App()

# EVENTS
TonTonYt.on 'todoShow', ->
  this.controller.showTodoHeader()
  this.controller.updateTodoRegion()
TonTonYt.on 'todoRemoved', ->
  if TonTonYt.collection.length is 0
    this.controller.showEmptyTodosView()
TonTonYt.on 'todoAdded', ->
  if TonTonYt.collection.length is 1
    this.controller.showTodoList()

AppController =
  showTodoHeader: ->
    mainRegion = TonTonYt.getRegion()
    mainRegion.show homeView
  updateTodoRegion: ->
    TonTonYt.collection.fetch().then ->
      if TonTonYt.collection.length > 0
        TonTonYt.controller.showTodoList()
      else
        TonTonYt.controller.showEmptyTodosView()
  showTodoList: ->
    TonTonYt.collectionView = new TodoListCollectionView( collection: TonTonYt.collection )
    homeView.getRegion('todoItems').empty()
    homeView.getRegion('todoItems').show( TonTonYt.collectionView )
  showEmptyTodosView: ->
    homeView.getRegion('todoItems').empty()
    homeView.getRegion('todoItems').show( new EmptyTodosView() )
  hideTodoList: ->
    homeView.getRegion('todoItems').empty()

HomeView = Mn.View.extend
  template: "#home-template"
  regions:
    todoItems: "#todo-items-region"
  events:
    'keypress #new-todo': "createTodo"
  createTodo: (ev) ->
    if ev.keyCode is 13
      TonTonYt.collection.createTodo { title: ev.currentTarget.value }
      ev.currentTarget.value = ''
homeView = new HomeView()

EmptyTodosView = Mn.View.extend
  template: '#empty-todo-template'
  className: 'empty-todo'

TodoItemModel = Backbone.Model.extend
  urlRoot: '/api/v1/todos'
  defaults:
    title: ''
    completed: false
  validate: (attrs, ops) ->
    if _.isEmpty( attrs.title )
      return "Todo name can't be empty"
  todoText: (text) ->
    frag = document.createDocumentFragment()
    frag.appendChild( document.createTextNode(text) )
    $(frag).text()
  initialize: ->
    this.set 'title', this.todoText( this.get('title') )

TodoItemView = Mn.View.extend
  tagName: 'li'
  template: "#todo-item-template"
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
  updateTodo: (ev) -> this.model.save { completed: ev.currentTarget.checked }
  deleteTodo: (ev) ->
    this.model.destroy()
    TonTonYt.trigger 'todoRemoved'

TodoListCollection = Backbone.Collection.extend
  url: '/api/v1/todos'
  model: TodoItemModel
  createTodo: (data) ->
    newTodo = new TodoItemModel data
    if newTodo.save()
      this.add newTodo
      TonTonYt.trigger 'todoAdded'

TodoListCollectionView = Mn.CollectionView.extend
  tagName: 'ul'
  className: 'todo-list'
  childView: TodoItemView
  collectionEvents:
    'change': 'statusMessages'

  statusMessages: (data) ->
    if this.collection.length is this.collection.filter({ completed: true }).length
      alert "Congratulations! You've done all of your todos! ;)"
