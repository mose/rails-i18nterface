# encoding: utf-8

require 'spec_helper'
require 'selenium/sauce'

describe 'translation' do

  it 'phase 1', js: true do
    visit 'http://in.codegreenit.com:9090/translate'
    expect(page.first(:xpath, "/html/body/div/div[2]/form/div[3]/div/div/span").text).to eq 'activerecord.attributes.article.active'
    link = page.first(:xpath, "/html/body/div/div/ul/li/span")
    link.click
    expect(page.first(:xpath, "/html/body/div/div[2]/form/div[3]/div/div/span").text).to eq 'title'
  end

  it 'phase 2', js: true do
  end

end
