require 'rails_helper'

RSpec.describe ErrorsController, type: :request do
  it 'should GET 400 page correctly' do
    # act.
    get '/errors/400'

    # assert.
    expect(response).to have_http_status(:success)
  end

  it 'should GET 403 page correctly' do
    # act.
    get '/errors/403'

    # assert.
    expect(response).to have_http_status(:success)
  end

  it 'should GET 404 page correctly' do
    # act.
    get '/errors/404'

    # assert.
    expect(response).to have_http_status(:success)
  end

  it 'should GET 500 page correctly' do
    # act.
    get '/errors/500'

    # assert.
    expect(response).to have_http_status(:success)
  end

  it 'should GET 503 page correctly' do
    # act.
    get '/errors/503'

    # assert.
    expect(response).to have_http_status(:success)
  end
end
