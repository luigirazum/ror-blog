require 'rails_helper'

RSpec.describe "'Posts' - [Controller]", type: :request do
  describe "'GET /index' => 'index' action at 'posts' controller" do
    before { get user_posts_path({ user_id: 1 }) }

    context "* 'status'", :status do
      it '- returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context "* 'template'", :template do
      it "- renders 'index' template" do
        expect(response).to render_template(:index)
        expect(response).to render_template('index')
      end

      it "- renders posts/index' template" do
        expect(response).to render_template('posts/index')
      end
    end

    context "* 'placeholder text'", :placeholder do
      it "- 'body' includes 'Posts for a User'" do
        expect(response.body).to match(/Posts for a User/)
      end
    end
  end

  describe "'GET /show' => 'show' action at 'posts' controller" do
    before { get user_post_path({ user_id: 1, id: 1 }) }

    context "* 'status'", :status do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context "* 'template'", :template do
      it "- renders 'show' template" do
        expect(response).to render_template(:show)
        expect(response).to render_template('show')
      end

      it "- renders 'posts/show' template" do
        expect(response).to render_template('posts/show')
      end
    end

    context "* 'placeholder text'", :placeholder do
      it "- 'body' includes 'details of a Post for a Single User'" do
        expect(response.body).to match(/details of a Post for a Single User/)
      end
    end
  end
end
