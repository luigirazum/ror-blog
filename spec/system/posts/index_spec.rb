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

    describe '- for each post' do
      it "> can see a post's title" do
        page.all('.post').each_with_index do |post, i|
          post_title = "Post ##{user_posts.reverse[i].id} | #{user_posts.reverse[i].title}"
          expect(post).to have_css('.post__header', text: post_title)
        end
      end

      it "> the post's title is clickable (link)" do
        page.all('.post').each_with_index do |post, i|
          expect(post).to have_css("a[href='/users/#{user.id}/posts/#{user_posts.reverse[i].id}']")
        end
      end

      it "> can see some of the post's body" do
        page.all('.post').each_with_index do |post, i|
          expect(post).to have_css('.post__text', text: user_posts.reverse[i].text)
        end
      end

      it "> can see 'Recent Comments' title" do
        page.all('.post').each do |post|
          expect(post).to have_css('h3', text: 'Recent Comments')
        end
      end

      context '> can see action buttons' do
        it '+ the [New Comment] button is available' do
          page.all('.post').each do |post|
            expect(post).to have_css('.post__counters')
            within(post) { expect(page).to have_button('New Comment') }
            within(post) { expect(page).to have_css('button', text: 'New Comment') }
          end
        end

        it '+ the [Give Like] button is available' do
          page.all('.post').each do |post|
            expect(post).to have_css('.post__counters')
            within(post) { expect(page).to have_button('Give Like') }
            within(post) { expect(page).to have_css('button', text: 'Give Like') }
          end
        end
      end

      context "> can see post's counters" do
        it '+ can see how many comments a post has' do
          page.all('.post').each_with_index do |post, i|
            within(post) do
              expect(page).to have_css('p.counter span', text: 'Comments:')
              expect(page).to have_css('p.counter', text: user_posts.reverse[i].comments_counter)
              expect(page).to have_css('p', text: /Comments: #{user_posts.reverse[i].comments_counter}/)
            end
          end
        end

        it '+ can see how many likes a post has' do
          page.all('.post').each_with_index do |post, i|
            within(post) do
              expect(page).to have_css('p.counter span', text: 'Likes:')
              expect(page).to have_css('p.counter', text: user_posts.reverse[i].likes_counter)
              expect(page).to have_css('p', text: /Likes: #{user_posts.reverse[i].likes_counter}/)
            end
          end
        end
      end
    end

    describe "- in the 'Recent Comments' section at each post" do
      context '> when a post has comments' do
        it '+ can see the five most recent comments' do
          page.all('.post').each_with_index do |post, i|
            expect(post).to have_css('.post--comments')
            within(post) { expect(page.all('.comment').count).to eq(user_posts.reverse[i].most_recent_comments.count) }
          end
        end
      end

      context '> when a post has NO comments' do
        it "+ can see 'The post has no comments yet!' message" do
          within(page.all('.post--comments')[0]) do
            expect(page).to have_css('p', text: /The post has no comments yet!/)
          end
        end
      end
    end

    describe '- action buttons at the bottom of the page' do
      it '> the [See all users] button is available' do
        expect(page).to have_css('a', text: 'See all users')
        expect(page).to have_link('See all users')
      end

      it '> the [Back to User] button is available' do
        expect(page).to have_css('a', text: 'Back to User')
        expect(page).to have_link('Back to User')
      end
    end
  end

  describe '* testing interactions' do
    before do
      visit user_posts_path(user)
    end

    describe '- for each post', :posts do
      context '> when clicking on [New Comment] button' do
        it '+ redirects to New Comment page' do
          user_posts.each do |post|
            find("form[action='#{new_post_comment_path(post)}']").click_on('New Comment')
            expect(page).to have_current_path(new_post_comment_path(post))
            visit user_posts_path(user)
          end
        end
      end

      context '> when clicking on [Give Like] button' do
        it "+ redirects to the user's posts page" do
          user_posts.each do |post|
            find("form[action='#{post_likes_path(post)}']").click_on('Give Like')
            expect(page).to have_current_path(user_posts_path(post.author))
            visit user_posts_path(user)
          end
        end

        it "+ the message 'You Liked the post successfully. is displayed" do
          user_posts.each do |post|
            find("form[action='#{post_likes_path(post)}']").click_on('Give Like')
            expect(page).to have_text('You Liked the post successfully.')
            visit user_posts_path(user)
          end
        end

        it '+ increases the number of Likes by 1' do
          user_posts.each do |post|
            find("form[action='#{post_likes_path(post)}']").click_on('Give Like')
            within(find("a[href='/users/#{user.id}/posts/#{post.id}']").find(:xpath, '..').find('.post__counters')) do
              likes_text = /Likes: #{post.likes_counter_was + 1}/
              expect(page).to have_css('p.counter', text: likes_text)
            end
          end
        end
      end
    end

    describe '- for page actions' do
      context '> when clicking on [See all users] button' do
        it "+ redirects to 'All users' page" do
          click_link('See all users')
          expect(page).to have_current_path(root_path)
        end
      end
    end
  end
end
