# encoding: utf-8

module RailsI18nterface
  module TranslateHelper

    def simple_filter(labels, param_name = 'filter', selected_value = nil)
      selected_value ||= params[param_name]
      filter = []
      labels.each do |item|
        if item.is_a?(Array)
          type, label = item
        else
          type = label = item
        end
        if type.to_s == selected_value.to_s
          filter << "<i>#{label}</i>"
        else
          link_params = params.merge({param_name.to_s => type})
          link_params.merge!({'page' => nil}) if param_name.to_s != 'page'
          filter << link_to(label, link_params)
        end
      end
      filter.join(' | ')
    end

    def n_lines(text, line_size)
      n_lines = 1
      if text.present?
        n_lines = text.split("\n").size
        n_lines = text.length / line_size + 1 if n_lines == 1 && text.length > line_size
      end
      n_lines
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
          out << "<li class=\"dir\"><span class=\"display\" data-id=\"#{k + key.to_s}\"></span>"
          out << key.to_s
          out << " <span class=\"num\">(#{val.length})</span>"
          out << list_namespace(k + key.to_s, val)
        else
          out << "<li class=\"item\" data-id=\"#{k + key.to_s}\">#{key}"
        end
        out << '</li>'
      end
      out << '</ul>'
    end

  end
end
