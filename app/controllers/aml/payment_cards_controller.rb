require_relative 'application_controller'

module AML
  class PaymentCardsController < ApplicationController
    authorize_actions_for AML::PaymentCard

    def index
      render :index, locals: { q: q, payment_cards: paginate(q.result.ordered) }
    end

    private

    def permitted_params
      params.fetch(:payment_card, {}).permit(:client_id)
    end

    def q
      @q ||= AML::PaymentCard.ransack params.fetch(:q, {}).permit!
    end
  end
end
