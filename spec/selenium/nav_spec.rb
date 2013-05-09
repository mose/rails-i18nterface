# encoding: utf-8

require 'spec_helper'

require 'sauce/capybara'
Capybara.javascript_driver = :sauce
Capybara.server_port = 9090
Sauce.config do |c|
  c[:browsers] = [
    ["Windows 7", "safari", "5"],
    ["Windows 7", "opera", "12"],
    ["Windows 7", "iehta", "9"]
  ]
end

describe 'What about the navigation' do
  it 'unfold an item when clicked', js: true do
    visit 'http://in.codegreenit.com:9090/translate'
    expect(page).to have_selector(:xpath,"/html/body/div/div/ul/li")
    expect(page.first(:xpath,"/html/body/div/div/ul/li/ul")).to be_nil
    page.first(:xpath,"/html/body/div/div/ul/li").click
    expect(page.first(:xpath,"/html/body/div/div/ul/li/ul")).not_to be_nil
  end
end
