class RailsI18nterface::Translation < ActiveRecord::Base

  def self.update(locale, keys)
    keys.each do |k, v|
      t = RailsI18nterface::Translation.where(key: k, locale: locale).first
      if t
        if !v || v == ''
          t.destroy!
          next
        elsif t.value != v
          t.value = v
          t.save!
        end
      elsif v != ''
        t = RailsI18nterface::Translation.new
        t.key = k
        t.locale = locale
        t.save!
      end
    end
  end

end
