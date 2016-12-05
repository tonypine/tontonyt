Mn = Marionette
# _.templateSettings = {
#   interpolate: /\{\{(.+?)\}\}/g
# };

App = Mn.Application.extend
  region: "#app"
  onStart: (options) ->
    this.AppController = AppController
    this.collection = new TodoListCollection()
    this.collectionView = new TodoListCollectionView( collection: this.collection )
    this.AppController.showTodoList()

AppController =
  showTodoList: ->
    mainRegion = TonTonYt.getRegion()
    homeView = new HomeView()
    mainRegion.show homeView
    TonTonYt.collection.fetch()
    homeView.getRegion('todoItems').show( TonTonYt.collectionView )

HomeView = Mn.View.extend
  template: "#home-template"
  regions:
    todoItems: "#todo-items-region"
  events:
    'keypress #new-todo': "createTodo"
  createTodo: (ev) ->
    if ev.keyCode is 13
      TonTonYt.collectionView.createTodo { title: ev.currentTarget.value }
      ev.currentTarget.value = ''

TodoItemModel = Backbone.Model.extend
  urlRoot: '/api/todos'
  defaults:
    completed: false
  validate: (attrs, ops) ->
    if attrs.title is ''
      "Todo name can't be empty"
    return

TodoItemView = Mn.View.extend
  tagName: 'li'
  template: "#todo-item-template"
  onDomRefresh: () ->
    $('input').iCheck
      checkboxClass: 'icheckbox_flat-red',
      radioClass: 'iradio_flat-red'
  modelEvents:
    'sync': 'render'
  events:
    'ifChanged input': 'updateTodo'
    'click .delete': 'deleteTodo'
  updateTodo: (ev) ->
    this.model.set 'completed', ev.currentTarget.checked
    this.model.save()
  deleteTodo: (ev) ->
    this.model.destroy()

TodoListCollection = Backbone.Collection.extend
  url: '/api/todos'
  model: TodoItemModel

TodoListCollectionView = Mn.CollectionView.extend
  tagName: 'ul'
  className: 'todo-list'
  childView: TodoItemView
  createTodo: (data) ->
    createdTodo = this.collection.create data
  collectionEvents:
    'sync': 'render'

window.TonTonYt = new App()
