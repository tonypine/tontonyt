require 'pry'
class Api::V1::TodosController < ApplicationController

  include ActionView::Helpers::SanitizeHelper

  def index
    @todos = Todo.order(:id).all
    render json: @todos
  end

  def create
    @todo = Todo.new
    @todo.title = params[:todo][:title]
    @todo.completed = params[:todo][:completed]
    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(params[:todo])
      head :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    head :no_content
  end

end
