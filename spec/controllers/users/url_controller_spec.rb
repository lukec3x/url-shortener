require 'rails_helper'

RSpec.describe Users::UrlController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_url) { 'https://example.com' }

  before do
    sign_in user
  end

  describe 'GET #top_visits' do
    before do
      create_list(:url, 10, visits: 5, deleted: false)
    end

    it 'returns top 10 most visited URLs' do
      get :top_visits

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(10)
      expect(json['data'].first['visits']).to eq(5)
    end

  end

  describe 'GET #index' do
    it 'returns a list of URLs for the current user' do
      create(:url, original_url: valid_url, user: user)

      get :index

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(1)
      expect(json['data'].first['original_url']).to eq(valid_url)
    end
  end

  describe 'POST #create' do
    let(:invalid_url) { 'invalid-url' }

    context 'with valid URL' do
      it 'creates a new URL' do
        post :create, params: { url: { original_url: valid_url } }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']['original_url']).to eq(valid_url)
      end
    end

    context 'with invalid URL' do
      it 'returns unprocessable entity' do
        post :create, params: { url: { original_url: invalid_url } }

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['status']['message']).to eq('Url is invalid.')
      end
    end
  end
end