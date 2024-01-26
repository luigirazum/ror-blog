require 'rails_helper'

def photo_link(user_name = 'user')
  "https://fakeimg.pl/160x160/252f3f,255/f29800,255/?font=roboto&text=#{user_name}+📸"
end

RSpec.describe "Page: 'All posts for a user' | 'posts#index'", type: :system do
  let!(:uname) { 'author' }
  let!(:user) { User.create(name: uname, bio: 'post author bio', photo: photo_link(uname)) }
  let!(:user_posts) { [] }
  let!(:post_audience) { [] }

  before(:each) do
    5.times do |i|
      user_posts << user.posts.create(title: "post ##{i + 1}", text: "Text for post ##{i + 1}")
    end

    7.times do |i|
      post_audience << User.create(name: "user#{i}", bio: "user#{i} bio", photo: photo_link("user#{i}"))
    end

    (0..user_posts.count - 2).to_a.reverse.each do |i|
      post_audience.each do |person|
        user_posts[i].comments.create(user: person, text: "comment from #{person.name}")
        user_posts[i].likes.create(user: person)
      end
    end
  end

  describe '* verifying page content' do
    before { visit user_posts_path(user) }

    context '- user info' do
      it "> can see the user's profile picture" do
        expect(page).to have_css("img[src*='#{photo_link(uname)}']")
      end

      it "> can see the user's username" do
        expect(page).to have_css('.hero__name', text: uname)
      end

      it '> can see the number of posts the user has written' do
        expect(page).to have_css('p.counter')
        expect(page).to have_css('p.counter span', text: 'Number of posts:')
        expect(page).to have_css('p.counter', text: user.posts_counter)
        expect(page).to have_css('p', text: /Number of posts: #{user.posts_counter}/)
      end
    end

    context "- can see all user's posts" do
      it "> can see 'All Post' title" do
        expect(page).to have_css('h2', text: 'All Posts')
      end

      it '> all posts are showed' do
        expect(page.all('.post').count).to eq(user.posts_counter)
      end
    end


  end
end
