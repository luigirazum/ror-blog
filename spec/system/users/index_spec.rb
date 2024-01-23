require 'rails_helper'

RSpec.describe "Page: 'All users' | 'users#index'", type: :system do
  let!(:users) { [] }

  before do
    names = %w[Tom Patricia Brad Leticia]
    5.times.each do |i|
      users << User.create(name: names[i], photo: "https://www.pngegg.com/en/png-#{names[i]}")
    end
  end

  describe '* verifying page content' do
    describe '- users info' do
      before { visit users_path }

      it '> can see the username of all other users' do
        page.all('a.user__link').each_with_index do |user, i|
          expect(user).to have_css('.hero__text .hero__name', text: users[i].name)
        end
      end

      it '> can see the profile picture for each user' do
        page.all('a.user__link').each_with_index do |user, i|
          expect(user).to have_css("img[src*='#{users[i].photo}']")
        end
      end

      it '> can see the number of posts each user has written' do
        page.all('a.user__link').each_with_index do |user, i|
          expect(user).to have_css('p.counter')
          expect(user).to have_css('p.counter span', text: 'Number of posts:')
          expect(user).to have_css('p.counter', text: users[i].posts_counter)
          expect(user).to have_css('p', text: /Number of posts: #{users[i].posts_counter}/)
        end
      end

      it '> every user is clickable (is a link)' do
        page.all('a.user__item').each_with_index do |user, i|
          expect(user).to have_css("a[href='/users/#{users[i].id}']")
        end
      end
    end
  end
end
