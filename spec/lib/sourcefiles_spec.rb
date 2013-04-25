require 'spec_helper'

describe RailsI18nterface::Sourcefiles do

  it 'grabs field from schema.rb' do
    expected = {
      'activerecord.models.article'=>['db/schema.rb'],
      'activerecord.attributes.article.title'=>['db/schema.rb'],
      'activerecord.attributes.article.body'=>['db/schema.rb'],
      'activerecord.attributes.article.created_at'=>['db/schema.rb'],
      'activerecord.attributes.article.updated_at'=>['db/schema.rb'],
      'activerecord.attributes.article.active'=>['db/schema.rb'],
      'activerecord.models.topic'=>['db/schema.rb'],
      'activerecord.attributes.topic.title'=>['db/schema.rb'],
      'activerecord.attributes.topic.created_at'=>['db/schema.rb'],
      'activerecord.attributes.topic.updated_at'=>['db/schema.rb']
    }
    root_dir = File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__)
    hash = RailsI18nterface::Sourcefiles.extract_activerecords(root_dir)
    hash.should == expected
  end

end