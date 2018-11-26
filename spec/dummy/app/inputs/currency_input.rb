# rubocop:disable all
class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    "<div class=\"input-group\">#{@builder.text_field(attribute_name, merged_input_options)}<div class=\"input-group-addon\">#{currency_addon}</div></div>"
      .html_safe
  end

  private

  def currency_addon
    currency_attribute_name = attribute_name.to_s + '_currency'
    # currency = object.send(attribute_name).currency
    value = object.send(currency_attribute_name)
    "<input type=\"hidden\" value=\"#{value}\" name=\"#{object_name}[#{currency_attribute_name}]\">#{value.presence || '???'}"
  end
end
