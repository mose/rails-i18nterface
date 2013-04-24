require 'spec_helper'

describe RailsI18nterface::Utils do
  include RailsI18nterface::Utils

  it 'Removes blanks from a hash' do
    hash = { a: 'a', b: { ba: '', bb: 'bb'}, c: '', d: { }, e: { ea: 'ee', eb: { } } }
    expected = { a: 'a', b: { bb: 'bb'}, e: { ea: 'ee' } }
    remove_blanks(hash).should == expected
  end

  it 'set nested transform a split of dotted flat string to a nested hash' do
    hash = { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa' } }, d: 'd' }
    expected = { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa', cab: 'cab' } }, d: 'd' }
    set_nested(hash, [:c, :ca, :cab], 'cab')
    hash.should == expected
  end

  describe 'to_deep_hash' do
    before :each do
      @shallow_hash = { 'pressrelease.label.one' => 'Pressmeddelande',
        'pressrelease.label.other' => 'Pressmeddelanden',
        'article' => 'Artikel', 'category' => '' }
      @deep_hash = { pressrelease: { label: { one: 'Pressmeddelande',
        other: 'Pressmeddelanden' } },
        article: 'Artikel', category: ''}
    end

    it 'convert shallow hash with dot separated keys to deep hash' do
      to_deep_hash(@shallow_hash).should == @deep_hash
    end

    it 'converts a deep hash to a shallow one' do
      to_shallow_hash(@deep_hash).should == @shallow_hash
    end

  end

  describe 'contains_key?' do
    it 'works' do
      hash = { foo: { bar: { baz: false } } }
      contains_key?(hash, '').should be_false
      contains_key?(hash, 'foo').should be_true
      contains_key?(hash, 'foo.bar').should be_true
      contains_key?(hash, 'foo.bar.baz').should be_true
      contains_key?(hash, :'foo.bar.baz').should be_true
      contains_key?(hash, 'foo.bar.baz.bla').should be_false
    end
  end

end