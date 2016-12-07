require 'rails_helper'
require 'pry'

RSpec.describe Api::V1::TodosController, :type => :controller do

  describe "Todos fetch index" do
    it "responds with two todos" do
      get :index, format: :json
      json = JSON.parse(response.body)
      expect( json.length ).to eq(2)
    end

    it 'responds with content_type :json' do
      get :index, format: :json
      expect( response.content_type.symbol ).to eq(:json)
    end

    it 'responds with status 200' do
      get :index, format: :json
      expect( response ).to be_success
    end
  end

  describe "Todo create" do
    context 'with empty title' do
      subject do
        post :create, format: :json, :todo => { :title => "", :completed => false }
        response
      end

      it "don't create the new todo with empty title" do
        expect{
          subject
        }.to_not change(Todo,:count)
      end

      it "responds with 422 status" do
        expect(subject.status).to eq(422)
      end
    end

    context 'with valid attributes' do
      subject do
        post :create, format: :json, :todo => { :title => "to-do 3", :completed => true }
        response
      end

      it "should create a new to-do" do
        expect{
          subject
        }.to change(Todo,:count)
      end

      it 'responds with content_type :json' do
        expect( subject.content_type.symbol ).to eq(:json)
      end

      it 'responds with 200 status' do
        expect(subject.status).to eq(201)
      end

      it 'create todo with right completed value' do
        json = JSON.parse(subject.body)
        expect(json["completed"]).to eq(true)
      end

      it 'create todo with right title value' do
        json = JSON.parse(subject.body)
        expect(json["title"]).to eq('to-do 3')
      end
    end
  end

  describe "Todo update" do
    context 'with empty title' do
      it "responds with status 422, unprocessable entity" do
        post :update, format: :json, :id => Todo.first.id, :todo => { :title => "" }
        expect(response.status).to eq(422)
      end
    end

    context 'with valid attributes' do
      subject do
        post :update, format: :json, :id => Todo.first.id, :todo => { :title => "edited todo", :completed => false }
        response
      end

      it "responds with content_type :json" do
        expect( subject.content_type.symbol ).to eq(:json)
      end

      it "responds with status 200" do
        expect(subject.status).to eq(200)
      end
    end
  end

  describe "Todo destroy" do
    context 'when destroy a to-do' do
      subject do
        post :destroy, :id => Todo.first.id
        response
      end

      it "destroy the to-do" do
        expect{
          subject
        }.to change(Todo, :count)
      end

      it "responds with status 204" do
        expect(subject.status).to eq(204)
      end
    end
  end

end
