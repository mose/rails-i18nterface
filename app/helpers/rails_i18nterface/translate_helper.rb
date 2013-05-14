# encoding: utf-8

module RailsI18nterface
  module TranslateHelper

    def simple_filter(labels, param_name = 'filter')
      filter = []
      labels.each do |label|
        if label.to_s == params[param_name].to_s
          filter << "<i>#{label}</i>"
        else
          link_params = params.merge({param_name.to_s => label})
          link_params.merge!({'page' => nil}) if param_name.to_s != 'page'
          filter << link_to(label, link_params)
        end
      end
      filter.join(' | ')
    end

    def build_namespace(h)
      out = '<ul>'
      dirs = {}
      root = []
      h.each do |k, v|
        if v.is_a? Hash
          dirs[k] = v
        else
          root << k
        end
      end
      out << '<li class="dir"><span class="display" data-id="."></span>ROOT'
      out << " <span class=\"num\">(#{root.length})</span>"
      out << '<ul>'
      root.each do |key|
        out << "<li class=\"item\" data-id=\"#{key.to_s}\">#{key}</li>"
      end
      out << '</ul>'
      out << '</ul>'
      out << list_namespace('', dirs)
    end

    def list_namespace(k, h)
      out = '<ul>'
      k != '' && k += '.'
      h.each do |key, val|
        if val.is_a? Hash
          out << '<li class="dir"><span class="display" data-id="%s"></span>%s <span class="num">(%d)</span>' %
            [ k + key.to_s, key.to_s, val.length]
          out << list_namespace(k + key.to_s, val)
        else
          out << '<li class="item" data-id="%s">%s' % [ k + key.to_s, key]
        end
        out << '</li>'
      end
      out << '</ul>'
    end

  end
end
