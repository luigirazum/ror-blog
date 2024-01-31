require 'rails_helper'

def photo_link(user_name = 'user')
  "https://fakeimg.pl/160x160/252f3f,255/f29800,255/?font=roboto&text=#{user_name}+:camera_with_flash:"
end

RSpec.describe "Page: 'A single post for a user' | 'posts#show'", type: :system do
  let!(:uname) { 'author' }
  let!(:user) { User.create(name: uname, bio: 'post author bio', photo: photo_link(uname)) }
  let!(:post) { user.posts.create(title: 'post title', text: "Text for post with title 'post title'") }
  let!(:post_audience) { [] }

  before(:each) do
    7.times do |i|
      post_audience << User.create(name: "user#{i}", bio: "user#{i} bio", photo: photo_link("user#{i}"))
    end

    post_audience.each do |person|
      post.comments.create(user: person, text: "comment from #{person.name}")
      post.likes.create(user: person)
    end
  end

  describe '* verifying page content' do
    before { visit user_post_path(user, post) }

    describe '- post info' do
      it "> can see the post's title" do
        post_title = "Post ##{post.id} | #{post.title}"
        expect(page).to have_css('.post h2', text: post_title)
      end

      it '> can see who wrote the post' do
        expect(page).to have_css('.post .post__author', text: user.name)
      end

      context "> can see post's counters" do
        it '+ can see how many comments the post has' do
          expect(page).to have_css('.post__counters span', text: 'Comments:')
          expect(page).to have_css('.post__counters', text: post.comments_counter)
          expect(page).to have_css('.post__counters p', text: /Comments: #{post.comments_counter}/)
        end

        it '+ can see how many likes the post has' do
          expect(page).to have_css('.post__counters span', text: 'Likes:')
          expect(page).to have_css('.post__counters', text: post.likes_counter)
          expect(page).to have_css('.post__counters p', text: /Likes: #{post.likes_counter}/)
        end
      end

      it "> can see the post's body" do
        expect(page).to have_css('.post .full-post__text', text: post.text)
      end

      it "> can see a 'Post Comments' title" do
        expect(page).to have_css('.post--comments__all h3', text: 'Post Comments')
      end

      describe "- at the 'Post Comments' section" do
        context '> when the post has comments' do
          it '+ can see all the comments the post has' do
            expect(page.all('.comment').count).to eq(post_audience.count)
          end

          it '+ can see the username of each commentor' do
            page.all('.comment').each_with_index do |comment, i|
              expect(comment).to have_css('.comment__user', text: /#{post_audience[i].name}:/)
            end
          end

          it '+ can see the comment each commentor left' do
            page.all('.comment').each_with_index do |comment, i|
              expect(comment).to have_content(/comment from #{post_audience[i].name}/)
            end
          end
        end

        context '> when the post has NO comments' do
          it "+ can see 'The post has no comments yet!' message" do
            Comment.where(post_id: post.id).destroy_all
            visit user_post_path(user, post)
            expect(page).to have_css('.post--comments__all p', text: /The post has no comments yet!/)
          end
        end
      end
    end

    describe '- action buttons at the bottom of the page' do
      it '> the [See all users] button is available' do
        expect(page).to have_css('a', text: 'See all users')
        expect(page).to have_link('See all users')
      end

      it '> the [See Author] button is available' do
        expect(page).to have_css('a', text: 'See Author')
        expect(page).to have_link('See Author')
      end

      it "> the [See Author's Posts] button is available" do
        expect(page).to have_css('a', text: "See Author's Posts")
        expect(page).to have_link("See Author's Posts")
      end
    end
  end

  describe '* testing interactions' do
    before { visit user_post_path(user, post) }

    describe '- for page actions' do
      context '> when clicking on [See all users] button' do
        it "+ redirects to 'All users' page" do
          click_link('See all users')
          expect(page).to have_current_path(root_path)
        end
      end

      context '> when clicking on [See Author] button' do
        it "+ redirects to 'Author'/'User' page" do
          click_link('See Author')
          expect(page).to have_current_path(user_path(user))
        end
      end

      context "> when clicking on [See Author's Posts] button" do
        it "+ redirects to 'Author'/'User's posts page" do
          click_link("See Author's Posts")
          expect(page).to have_current_path(user_posts_path(user))
        end
      end
    end
  end
end
