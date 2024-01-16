require 'rails_helper'

RSpec.describe "'Users' - [Controller]", type: :request do
  describe "'GET /index' => 'index' action at 'Users' controller" do
    before { get users_path }

    context "* 'status'", :status do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context "* 'template'", :template do
      it "- renders 'index' template" do
        expect(response).to render_template(:index)
        expect(response).to render_template('index')
      end

      it "- renders users/index' template" do
        expect(response).to render_template('users/index')
      end
    end

    context "* 'placeholder text'", :placeholder do
      it "- 'body' includes 'the list of Users'" do
        expect(response.body).to match(/Lists all the users/)
      end
    end
  end

  describe "'GET /show' => 'show' action at 'users' controller" do
    before { get user_path({ id: 1 }) }

    context "* 'status'", :status do
      it '- returns http success/ok' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
