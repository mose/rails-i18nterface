require 'spec_helper'

describe RailsI18nterface::Sourcefiles do

  it "grabs field from schema.rb" do
    expected = {
      "activerecord.models.article"=>"db/schema.rb",
      "activerecord.attributes.article.title"=>"db/schema.rb",
      "activerecord.attributes.article.body"=>"db/schema.rb",
      "activerecord.attributes.article.created_at"=>"db/schema.rb",
      "activerecord.attributes.article.updated_at"=>"db/schema.rb",
      "activerecord.attributes.article.active"=>"db/schema.rb",
      "activerecord.models.topics"=>"db/schema.rb",
      "activerecord.attributes.topics.title"=>"db/schema.rb",
      "activerecord.attributes.topics.created_at"=>"db/schema.rb",
      "activerecord.attributes.topics.updated_at"=>"db/schema.rb"
    }

    hash = RailsI18nterface::Sourcefiles.extract_activerecords
    hash.should == expected
  end

end