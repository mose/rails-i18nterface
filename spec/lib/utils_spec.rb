# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Utils do
  include RailsI18nterface::Utils

  describe '.remove_blanks' do
    let(:hash) { { a: 'a', b: { ba: '', bb: 'bb' }, c: '', d: {}, e: { ea: 'ee', eb: {} } } }
    let(:expected) { { a: 'a', b: { bb: 'bb' }, e: { ea: 'ee' } } }
    it { expect(remove_blanks hash).to eq expected }
  end

  describe '.set_nested' do
    let(:hash) { { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa' } }, d: 'd' } }
    let(:expected) { { a: { aa: 'aa' }, b: '', c: { ca: { caa: 'caa', cab: 'cab' } }, d: 'd' } }
    before { set_nested(hash, [:c, :ca, :cab], 'cab') }
    it 'set nested transform a split of dotted flat string to a nested hash' do
      expect(hash).to eq expected
    end
  end

  describe '.deep_sort' do
    let(:hash) { { b: '', a: { aa: 'aa' }, d: 'd', c: [cb: ['b', 'a', 'c'], ca: { caa: 'caa' }] } }
    let(:expected) { { a: { aa: 'aa' }, b: '', c: [ca: { caa: 'caa' }, cb: ['a', 'b', 'c']], d: 'd' } }
    it 'can deep sort hashes' do
      expect(deep_sort hash).to eq expected
    end
  end

  describe 'to_deep_hash' do
    let(:shallow_hash) { 
      {
        'pressrelease.label.one' => 'Pressmeddelande',
        'pressrelease.label.other' => 'Pressmeddelanden',
        'article' => 'Artikel',
        'category' => ''
      }
    }
    let(:deep_hash) {
      {
        pressrelease: {
          label: { 
            one: 'Pressmeddelande',
            other: 'Pressmeddelanden'
          }
        },
        article: 'Artikel',
        category: ''
      }
    }

    describe '.to_deep_hash' do
      it 'convert shallow hash with dot separated keys to deep hash' do
        expect(to_deep_hash shallow_hash).to eq deep_hash
      end
    end

    describe '.to_shallow_hash' do
      it 'converts a deep hash to a shallow one' do
        expect(to_shallow_hash deep_hash).to eq shallow_hash
      end
    end

  end

  describe '.contains_key?' do
    let(:hash) { { foo: { bar: { baz: false } } } }
    it 'works' do
      expect(contains_key? hash, '').to be_falsey
      expect(contains_key? hash, 'foo').to be_truthy
      expect(contains_key? hash, 'foo.bar').to be_truthy
      expect(contains_key? hash, 'foo.bar.baz').to be_truthy
      expect(contains_key? hash, :'foo.bar.baz').to be_truthy
      expect(contains_key? hash, 'foo.bar.baz.bla').to be_falsey
    end
  end

end
