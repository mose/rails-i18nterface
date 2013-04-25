# encoding: utf-8

require 'spec_helper'

describe 'searching' do

  describe 'keys' do

    context 'using contains' do

      it 'finds the correct keys' do
        visit '/translate'
        select 'Key contains', from: 'key_type'
        fill_in 'key_pattern', with: 'ey2'
        click_button 'Search'

        page.should have_content 'key2'
      end

    end

    context 'using starts with' do
      it 'finds the correct keys' do
        visit '/translate'
        select 'Key starts with', from: 'key_type'
        fill_in 'key_pattern', with: 'article.k'
        click_button 'Search'

        page.should have_content 'article.key2'
      end
    end
  end

  describe 'values' do

    context 'using contains' do

      it 'finds the correct values' do
        visit '/translate'
        select 'contains', from: 'text_type'
        fill_in 'text_pattern', with: '1 year'
        click_button 'Search'

        page.should have_content 'over 1 year'
      end

    end

    context 'using equals' do

      it 'finds the correct values' do
        visit '/translate'
        select 'equals', from: 'text_type'
        fill_in 'text_pattern', with: 'over 1 year'
        click_button 'Search'

        page.should have_content 'over 1 year'
      end

    end

  end

end
