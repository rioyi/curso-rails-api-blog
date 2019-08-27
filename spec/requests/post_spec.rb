require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /post' do
    before { get '/posts'}

    it 'should return OK' do
      payload = JSON.parse(response)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe 'with  data in the DB' do
    let(:posts) { create_list(:post, 10, published: true)}
    before { get '/posts'}

    it 'should return all the published posts' do
      payload = JSON.parse(response)
      expect(payload).to eq(posts.size)
      expect(response).to have_http_status(200)

    end
  end

  describe 'GET /post/{id}' do
    let(:post) { create(:post) }

    it 'should return a post' do
      get "/get/#{post.id}"
      payload = JSON.parse(response)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
    end

  end
end