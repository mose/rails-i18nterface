# encoding: utf-8

require 'spec_helper'
require 'selenium/sauce'

describe 'What about the navigation' do

  it 'unfold an item when clicked', js: true do
    visit 'http://in.codegreenit.com:9090/translate'
    expect(page).to have_selector(:xpath, "/html/body/div/div/ul/li")
    expect(page.first(:xpath, "/html/body/div/div/ul/li/ul")).to be_nil
    page.first(:xpath, "/html/body/div/div/ul/li").click
    expect(page.first(:xpath, "/html/body/div/div/ul/li/ul")).not_to be_nil
  end

  it 'displays the inside elements from a namespace', js: true do
    visit 'http://in.codegreenit.com:9090/translate'
    expect(page.first(:xpath, "/html/body/div/div[2]/form/div[3]/div/div/span").text).to eq 'activerecord.attributes.article.active'
    page.first(:xpath, "/html/body/div/div/ul/li/span").click
    expect(page.first(:xpath, "/html/body/div/div[2]/form/div[3]/div/div/span").text).to eq 'title'
  end

end
