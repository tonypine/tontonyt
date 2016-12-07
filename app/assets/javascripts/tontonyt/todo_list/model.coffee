@TodoItemModel = Backbone.Model.extend
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

@TodoListCollection = Backbone.Collection.extend
  url: '/api/v1/todos'
  model: TodoItemModel

