module AML
  module ApplicationHelper
    def app_title
      "AML #{AppVersion}-#{AML::VERSION}"
    end

    def boolean_humanized(flag)
      flag ? content_tag(:span, 'ДА') : content_tag(:span, 'нет', class: 'text-muted')
    end

    def client_risk_category_link(client, risk_category)
      css_class = client.risk_category == risk_category ? 'btn btn-primary' : 'btn btn-default'
      link_to risk_category || 'не установлена',
              client_path(client, client: { risk_category: risk_category }),
              method: :put,
              class: css_class
    end

    def top_breadcrumbs
      return if breadcrumbs.empty?

      content_tag :ol, class: 'breadcrumb' do
        render_breadcrumbs tag: :li, separator: '', class: '', item_class: '', divider_class: '', active_class: 'active'
      end
    end

    def title_with_counter(title, count, hide_zero: true, css_class: 'badge-success')
      [
        title,
        counter_badge(count, hide_zero: hide_zero, css_class: css_class)
      ].join(' ').html_safe
    end

    def paginate(objects, options = {})
      return unless objects.respond_to? :total_pages

      options.reverse_merge!(theme: 'twitter-bootstrap-3')

      super(objects, options)
    end

    def counter_badge(count, hide_zero: true, css_class: '')
      content_tag(:span,
                  hide_zero && count.to_i.zero? ? '' : count.to_s,
                  class: ['badge', css_class].compact.join(' '),
                  data: { title_counter: true, count: count.to_i })
    end

    def active_style_tab(workflow_state)
      workflow_state == :none ? :inclusive : :exact
    end

    def active_style_order(workflow_state)
      workflow_state == :pending ? :inclusive : :exact
    end

    def humanized_time_in_current_time_zone(time)
      return 'время не известно' unless time

      content_tag(:span, time.in_time_zone(current_time_zone.name), class: 'text-nowrap')
    end
  end
end
