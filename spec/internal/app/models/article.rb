class Article
  def validate
    something([t(:'article.key1') + "#{t('article.key2')}"])
    I18n.t 'article.key3'
    I18n.t 'article.key3'
    I18n.t :'article.key4'
    I18n.translate :'article.key5'
    'bla bla t("blubba bla") foobar'
    'bla bla t ' + "blubba bla" + ' foobar'
  end
  def something
  end
end
