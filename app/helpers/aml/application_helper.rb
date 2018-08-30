# frozen_string_literal: true

module AML
  module ApplicationHelper
    def top_breadcrumbs
      return if breadcrumbs.empty?
      content_tag :ol, class: 'breadcrumb' do
        render_breadcrumbs tag: :li, separator: '', class: '', item_class: '', divider_class: '', active_class: 'active'
      end
    end

    def title_with_counter(title, count, hide_zero: true, css_class: '')
      [
        title,
        counter_badge(count, hide_zero: hide_zero, css_class: css_class)
      ].join(' ').html_safe
    end

    def paginate(objects, options = {})
      options.reverse_merge!(theme: 'twitter-bootstrap-3')

      super(objects, options)
    end

    def counter_badge(count, hide_zero: true, css_class: '')
      content_tag(:span,
                  hide_zero && count.to_i.zero? ? '' : count.to_s,
                  class: ['badge', css_class].compact.join(' '),
                  data: { title_counter: true, count: count.to_i })
    end

    def app_title
      "AML #{AppVersion}"
    end

    def document_active_type(workflow_state)
      workflow_state == :pending ? :inclusive : :exact
    end

    def order_active_type(workflow_state)
      workflow_state == :none ? :inclusive : :exact
    end

    DEFAULT_TYPE = :warning
    TYPES = { alert: :error, notice: :info }.freeze

    def noty_flash_javascript(key, message)
      noty_type = TYPES[key.to_sym] || DEFAULT_TYPE

      "window.Flash.show(#{noty_type.to_json}, #{message.to_json})"
    end
  end
end
