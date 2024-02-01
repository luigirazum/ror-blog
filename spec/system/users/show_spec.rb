require 'rails_helper'

def photo_link(user_name = 'user')
  "https://fakeimg.pl/160x160/252f3f,255/f29800,255/?font=roboto&text=#{user_name}+📸"
end

RSpec.describe "Page: 'User' | 'users#show'", type: :system do
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
    before { visit user_path(user) }

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

      it "> can see the user's bio" do
        expect(page).to have_css('.bio h2', text: /Bio/)
      end
    end

    describe "- can see user's three most recent posts" do
      it "> can see 'Recent Posts' title" do
        expect(page).to have_css('h2', text: 'Recent Posts')
      end

      it '> the three most recent posts are showed' do
        expect(page.all('.post').count).to eq(user.most_recent_posts.count)
        expect(user_posts.reverse[0..2]).to eq(user.most_recent_posts)
      end

      context "> when the user hasn't post anything" do
        it "+ can see 'The user has no posts yet! message" do
          new_user = User.create(name: 'Without posts', bio: 'Without bio', photo: photo_link('No Posts'))
          visit user_path(new_user)
          expect(page).to have_css('.user-posts p', text: /The user has no posts yet!/)
        end
      end
    end

    describe '- pagination controls' do
      it '> are hidden because the view can hold 3 posts' do
        expect(page).not_to have_css('.pagination')
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

    describe '- action buttons at the bottom of the page' do
      it '> the [See all posts] button is available' do
        expect(page).to have_css('a', text: 'See all posts')
        expect(page).to have_link('See all posts')
      end
    end
  end

  describe '* testing interactions' do
    before { visit user_path(user) }

    describe '- for each post' do
      context "> when clicking on the [Post's Title]" do
        it "+ redirects to the 'Post's page" do
          page.all('.post').each_with_index do |_post, i|
            post_title = "Post ##{user_posts.reverse[i].id} | #{user_posts.reverse[i].title}"
            click_on(post_title)
            expect(page).to have_current_path(user_post_path(user, user_posts.reverse[i]))
            visit user_path(user)
          end
        end
      end

      context '> when clicking on [New Comment] button' do
        it '+ redirects to New Comment page' do
          user_posts.reverse[0..2].each do |post|
            find("form[action='#{new_post_comment_path(post)}']").click_on('New Comment')
            expect(page).to have_current_path(new_post_comment_path(post))
            visit user_path(user)
          end
        end
      end

      context '> when clicking on [Give Like] button' do
        it "+ redirects to the user's posts page" do
          user_posts.reverse[0..2].each do |post|
            find("form[action='#{post_likes_path(post)}']").click_on('Give Like')
            expect(page).to have_current_path(user_posts_path(post.author))
            visit user_path(user)
          end
        end

        it "+ the message 'You Liked the post successfully. is displayed" do
          user_posts.reverse[0..2].each do |post|
            find("form[action='#{post_likes_path(post)}']").click_on('Give Like')
            expect(page).to have_text('You Liked the post successfully.')
            visit user_path(user)
          end
        end

        it '+ increases the number of Likes by 1' do
          user_posts.reverse[0..2].each do |post|
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
      context '> when clicking on [See all posts] button' do
        it "+ redirects to 'All users' posts page" do
          click_link('See all posts')
          expect(page).to have_current_path(user_posts_path(user))
        end
      end
    end
  end
end
