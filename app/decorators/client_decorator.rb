class ClientDecorator < ApplicationDecorator
  def id
    h.link_to object.id, h.client_path(object.id)
  end

  def total_income_amount
    h.humanized_money_with_symbol object.total_income_amount
  end

  def current_order
    h.link_to "##{object.current_order.id}", h.order_path(object.current_order) if object.current_order.present?
  end

  def risk_category
    object.risk_category || none
  end
end
