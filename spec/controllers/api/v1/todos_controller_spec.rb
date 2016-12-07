require 'rails_helper'
require 'pry'

RSpec.describe Api::V1::TodosController, :type => :controller do

  describe "Todos fetch index" do
    it "should bring two todos" do
      get :index, format: :json
      json = JSON.parse(response.body)
      expect( json.length ).to eq(2)
      expect( response.content_type.symbol ).to eq(:json)
      expect( response ).to be_success
    end
  end

  describe "Todo create" do
    it "should not create the new todo with empty title" do
      expect{
        post :create, format: :json, :todo => { :title => "", :completed => false }
      }.to_not change(Todo,:count)
      expect(response.status).to eq(422)
    end
    it "should create a new to-do" do
      expect{
        post :create, format: :json, :todo => { :title => "to-do 3", :completed => true }
      }.to change(Todo,:count)
      json = JSON.parse(response.body)
      expect(json["completed"]).to eq(true)
      expect( response.content_type.symbol ).to eq(:json)
      expect(response.status).to eq(201)
    end
  end

  describe "Todo update" do
    it "should not update the todo with empty title" do
      post :update, format: :json, :id => Todo.first.id, :todo => { :title => "" }
      expect(response.status).to eq(422)
    end
    it "should update the todo" do
      post :update, format: :json, :id => Todo.first.id, :todo => { :title => "edited todo", :completed => false }
      expect( response.content_type.symbol ).to eq(:json)
      expect(response.status).to eq(422)
    end
  end

  describe "Todo destroy" do
    it "the to-do should be destroyed" do
      expect{
        post :destroy, :id => Todo.first.id
      }.to change(Todo,:count)
      expect(response.status).to eq(204)
    end
  end

end
