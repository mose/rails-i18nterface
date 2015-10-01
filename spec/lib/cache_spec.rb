# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Cache do
  include RailsI18nterface::Cache

  let(:cachefile) { File.expand_path(File.join('..', 'files', 'cache_test'), __FILE__) }

  after { FileUtils.rm cachefile if File.exists? cachefile }

  describe '.save' do
    let(:a) { { a: 'a' } }
    before { cache_save a, cachefile }
    it 'stores cache of an object' do
      expect(File.exists? cachefile).to be_truthy
    end
  end

  describe '.load' do
    context 'reads cache from marshalled file' do
      let(:a) { { a: 'a' } }
      let(:b) { cache_load cachefile }
      before { cache_save a, cachefile }
      it { expect(b).to eq a }
    end

    context 'when the cache if not present' do
      before { 
        @b = cache_load cachefile do
          20
        end
      }
      it { expect(@b).to be 20 }
      it { expect(File.exists? cachefile).to be_truthy }
    end

    context 'when the cache if not present, using an argument' do
      before {
        @b = cache_load cachefile, 'something' do |options| 
          options
        end
      }
      it { expect(@b).to eq 'something' }
      it { expect(File.exists? cachefile).to be_truthy }
    end
  end


end
