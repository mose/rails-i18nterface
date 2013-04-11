require 'spec_helper'

describe 'searching' do

  describe 'keys' do
    context 'using contains' do

      it 'finds the correct keys' do
        visit root_path
        select 'contains', from: 'key_type'
        fill_in 'Key', with: 'ell'
        click_button 'Search'

        page.should have_content 'hello'
      end

    end

    context 'using starts with' do
      it 'finds the correct keys' do
        visit root_path
        select 'starts with', from: 'key_type'
        fill_in 'Key', with: 'he'
        click_button 'Search'

        page.should have_content 'hello'
      end
    end
  end

  describe 'values' do

    context 'using contains' do

      it 'finds the correct values' do
        visit root_path
        select 'contains', from: 'text_type'
        fill_in 'Text', with: 'ell'
        click_button 'Search'

        page.should have_content 'Hello world'
      end

    end

    context 'using equals' do

      it 'finds the correct values' do
        visit root_path
        select 'equals', from: 'text_type'
        fill_in 'Text', with: 'Hello world'
        click_button 'Search'

        page.should have_content 'Hello world'
      end

    end

  end

end
