require 'rails_helper'

RSpec.describe "'Users' - [Controller]", type: :request do
  describe "'GET /index' => 'index' action at 'Users' controller" do
    before { get users_path }

    context "* 'status'", :status do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/users/1'
      expect(response).to have_http_status(:success)
    end
  end
end
