class ApplicationDecorator < Draper::Decorator
  delegate_all

  def alive?
    if object.alive?
      'действующий'
    else
      h.content_tag :span, 'архив', class: 'label label-default'
    end
  end

  def first_name
    object.first_name.presence || none
  end

  def surname
    object.surname.presence || none
  end

  def patronymic
    object.patronymic.presence || none
  end

  def birth_date
    return none if object.birth_date.nil?

    h.humanized_time_in_current_time_zone object.birth_date
  end

  def aml_status
    object.aml_status.presence || h.content_tag(:span, 'не установлен', class: 'label label-default')
  end

  private

  def none
    h.content_tag :span, 'не указано', class: 'text-muted'
  end
end
