require 'test_helper'

class Api::TodosControllerTest < ActionController::TestCase

  setup do
    @todo = todos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:todos)
  end

  test "should create todo" do
    assert_difference('Todo.count') do
      post :create, todo: { completed: @todo.completed, title: @todo.title }
    end

  end

  test "should update todo" do
    put :update, id: @todo, todo: { completed: @todo.completed, title: @todo.title }
  end

  test "should destroy todo" do
    assert_difference('Todo.count', -1) do
      delete :destroy, id: @todo
    end

  end
end
