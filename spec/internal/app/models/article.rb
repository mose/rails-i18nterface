# encoding: utf-8

class Article

  def validate
# rubocop : disable all
    something([t(:'article.key1') + "#{t('article.key2')}"])
    I18n.t 'article.key3'
    I18n.t 'article.key3'
    I18n.t :'article.key4', count: 3
    I18n.translate :'article.key5'
    'bla bla t("blubba bla") foobar'
    'bla bla t ' + "blubba bla" + ' foobar'
    I18n.t :'article.key6', :count => 3
# rubocop : enable all
  end

  def something
  end

end
