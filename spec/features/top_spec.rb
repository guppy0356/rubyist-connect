require 'rails_helper'

feature 'Top spec' do
  scenario 'トップページに OGPタグが設定されている' do
    visit root_path

    doc = Nokogiri::HTML(page.html)
    expect(doc.css('meta[property="og:image"]')[0]['content']).to include 'rubyist-connect-symbol-mark'
    expect(doc.css('meta[property="og:title"]')[0]['content']).to include 'Rubyist Connect'
    expect(doc.css('meta[property="og:description"]')[0]['content']).to include I18n.t('top.index.description')
    expect(doc.css('meta[name="description"]')[0]['content']).to include I18n.t('top.index.description')
  end

  scenario 'ログイン中はトップページにアクセスできない' do
    sign_in_as_new_user

    visit root_path

    expect(current_path).to eq users_path
  end

  scenario 'activeなユーザーが表示されること' do
    create :user, :with_inactive_fields
    active = create :user
    visit root_path
    within '.new-members .user-icons' do
      imgs = all('img')
      expect(imgs.size).to eq 1
      expect(imgs.first['alt']).to eq active.name
    end

    expect(find('.user-count-number').text).to eq '1'
  end

  scenario 'ランダムにユーザーが21名表示されること', retry: 3 do
    100.times do
      create :user
    end

    # 3回の表示結果の比較(先頭ユーザー名)
    # ランダムなので偶然3回とも同じになる可能性あり
    first_users = []

    visit root_path
    within '.new-members .user-icons' do
      imgs = all('img')
      first_users << imgs.first['alt']
      expect(imgs.size).to eq 21
    end

    visit root_path
    within '.new-members .user-icons' do
      imgs = all('img')
      first_users << imgs.first['alt']
      expect(imgs.size).to eq 21
    end

    visit root_path
    within '.new-members .user-icons' do
      imgs = all('img')
      first_users << imgs.first['alt']
      expect(imgs.size).to eq 21
    end

    expect(first_users.combination(2).all?{|a, b| a != b}).to be_truthy
  end
end
