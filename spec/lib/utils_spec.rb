require 'spec_helper'

describe RailsI18nterface::Utils do
  include RailsI18nterface::Utils

  it "Removes blanks from a hash" do
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

end