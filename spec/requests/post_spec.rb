require 'rails_helper'
require 'byebug'

RSpec.describe 'Posts', type: :request do
  describe 'GET /post' do

    it 'should return OK' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end

    describe "Search" do
      let!(:hola_mundo) { create(:published_post, title: 'Hola mundo') }
      let!(:hola_mary) { create(:published_post, title: 'Hola mary') }
      let!(:vamos_ruby) { create(:published_post, title: 'Vamos ruby') }
      it 'should filter posts by title' do
        get '/posts?search=Hola'
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map {|p| p['id']}.sort).to eq([hola_mundo.id, hola_mary.id].sort)
        expect(response.status).to have_http_status(:ok)
      end
    end

  end

  describe 'with  data in the DB' do
    let!(:posts) { create_list(:post, 10, published: true)}

    it 'should return all the published posts' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)

    end
  end

  describe 'GET /post/{id}' do
    let!(:post) { create(:post) }

    it 'should return a post' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)
    end
  end

    describe 'POST /posts' do
      let!(:user){ create(:user) }
      it 'should create a post' do
        req_payload = {
          posts: {
            title: 'titulo',
            content: 'contenido',
            published: false,
            user_id: user.id
          }
        }
        post '/posts', params: req_payload
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['id']).to_not be_nil
        expect(response).to have_http_status(:created)
      end

      it 'should return error message on invalid post' do
        # sin titulo
        req_payload = {
          posts: {
            content: 'contenido',
            published: false,
            user_id: user.id
          }
        }
        post '/posts', params: req_payload
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['error']).to_not be_empty
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end


    describe 'PUT /posts/{id}' do
      let!(:article) { create(:post) }
      it 'should update a post' do
        req_payload = {
          posts: {
            title: 'titulo',
            content: 'contenido',
            published: true,
          }
        }
        # PUT HTTP
        put "/posts/#{article.id}", params: req_payload
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['id']).to eq(article.id)
        expect(response).to have_http_status(:ok)
      end

      it 'should return error message on invalid post' do
        # sin titulo
        req_payload = {
          posts: {
            title: nil,
            content: nil,
            published: false,
          }
        }
        put "/posts/#{article.id}", params: req_payload
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['error']).to_not be_empty
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end



end