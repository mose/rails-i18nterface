# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Utils do
  include RailsI18nterface::Utils

  it 'Removes blanks from a hash' do
    hash = { a: 'a', b: { ba: '', bb: 'bb'}, c: '', d: { }, e: { ea: 'ee', eb: { } } }
    expected = { a: 'a', b: { bb: 'bb'}, e: { ea: 'ee' } }
    expect(remove_blanks hash).to eq expected
  end

  it 'set nested transform a split of dotted flat string to a nested hash' do
    hash = { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa' } }, d: 'd' }
    expected = { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa', cab: 'cab' } }, d: 'd' }
    set_nested(hash, [:c, :ca, :cab], 'cab')
    expect(hash).to eq expected
  end

  it 'can deep sort hashes' do
    hash = { b: '', a: { aa: 'aa' }, d: 'd', c: [ cb: [ 'b', 'a', 'c' ], ca: { caa: 'caa' }] }
    expected = { a: { aa: 'aa' }, b: '', c: [ ca: { caa: 'caa' }, cb: [ 'a', 'b', 'c' ] ], d: 'd' }
    expect(deep_sort hash).to eq expected
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
      expect(to_deep_hash @shallow_hash).to eq @deep_hash
    end

    it 'converts a deep hash to a shallow one' do
      expect(to_shallow_hash @deep_hash).to eq @shallow_hash
    end

  end

  describe 'contains_key?' do
    it 'works' do
      hash = { foo: { bar: { baz: false } } }
      expect(contains_key? hash, '').to be_false
      expect(contains_key? hash, 'foo').to be_true
      expect(contains_key? hash, 'foo.bar').to be_true
      expect(contains_key? hash, 'foo.bar.baz').to be_true
      expect(contains_key? hash, :'foo.bar.baz').to be_true
      expect(contains_key? hash, 'foo.bar.baz.bla').to be_false
    end
  end

end