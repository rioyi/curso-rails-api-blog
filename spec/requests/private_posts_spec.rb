require 'rails_helper'

RSpec.describe "Posts with authentication", type: :request do

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }
  let!(:auth_headers) { { "Authorization" => "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { "Authorization"=> "Bearer #{other_user.auth_token}" } }
  # convencio para auth en el header va un (Authorization: Bearer xxxxxxx)

  describe "GET /post/{id}" do
    context "with valid auth" do
      context "when requisting other`s author post" do
        context "when post is public" do

          before { get "/posts/#{other_user_post.id}", headers: auth_headers }

          # payload
          context "payload" do
            subject { payload }
            it { is_expected.to include('id') }
          end

          # response
          context "response" do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end

        context "when post is draft" do

          before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }

          # payload
          context "payload" do
            subject { payload }
            it { is_expected.to include(:error) }
          end

          # response
          context "response" do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
          end
        end
      end

      context "when requisting user`s post" do
      end
    end
  end

  describe "POST /post" do
  end

  describe "PUT /post" do
  end

  private

  def payload
    # es de hash es para acceder a la key como simbolo, string o como sea
    JSON.parse(response.body).with_indifferent_access
  end
end
