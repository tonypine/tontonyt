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
  deleteTodo: (ev) -> this.model.destroy()

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
    'change': 'statusMessages'

  statusMessages: (data) ->
    if this.collection.length is this.collection.filter({ completed: true }).length
      alert "Congratulations! You've done all of your todos! ;)"

window.TonTonYt = new App()
