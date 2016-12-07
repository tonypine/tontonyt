describe 'App', ->

  describe 'Everything is defined', ->

    it "app is defined", ->
      expect(app).toBeDefined()

    it "HomeView is defined", ->
      expect(HomeView).toBeDefined()

    it "EmptyTodosView is defined", ->
      expect(EmptyTodosView).toBeDefined()

    it "TodoItemView is defined", ->
      expect(TodoItemView).toBeDefined()

    it "TodoListCollectionView is defined", ->
      expect(TodoListCollectionView).toBeDefined()

    it "TodoListController is defined", ->
      expect(TodoListController).toBeDefined()

    it "TodoItemModel is defined", ->
      expect(TodoItemModel).toBeDefined()

  describe 'Creating Todos', ->

    it "Todo with empty title isn't valid", ->
      todo = new TodoItemModel({ title: '' })
      expect( todo.isValid() ).toBe( false )

