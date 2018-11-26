# Этот input перекрывает input из formtastic и поэтому его не возможно использовать в админке
# Пример как это обходится https://github.com/activeadmin/activeadmin/issues/2703

class DatetimePickerInput < DatePickerInput
  private

  def display_pattern
    I18n.t('datepicker.dformat', default: '%Y-%m-%d') + ' ' +
      I18n.t('timepicker.dformat', default: '%R')
  end

  def picker_pattern
    I18n.t('datepicker.pformat', default: 'YYYY-MM-DD') + ' ' +
      I18n.t('timepicker.pformat', default: 'HH:mm')
  end
end
