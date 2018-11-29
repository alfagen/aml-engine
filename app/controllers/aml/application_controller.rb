module AML
  class ApplicationController < ::ApplicationController
    helper NotyFlash::ApplicationHelper
    helper LocalizedRender::Engine.helpers

    include Pagination
    rescue_from ActionController::InvalidAuthenticityToken, with: :rescue_invalid_authenticity_token
    rescue_from Workflow::Error, with: :humanized_error

    prepend_before_action :require_login

    helper_method :document_kinds, :current_time_zone

    ensure_authorization_performed except: %i[error reset_db drop_clients drop_orders]

    def error
      raise 'test error'
    end

    def reset_db
      raise 'Доступно только на боевом' if Rails.env.production?

      AML.seed_demo!

      flash.alert = 'Данные полностью сброшены'
      redirect_to root_path
    end

    def drop_clients
      raise 'Доступно только на боевом' if Rails.env.production?

      AML::ClientInfo.delete_all
      AML::Client.destroy_all

      flash.alert = 'Клиенты сброшены'
      redirect_to root_path
    end

    def drop_orders
      raise 'Доступно только на боевом' if Rails.env.production?

      AML::Client.update_all aml_order_id: nil, aml_status_id: nil, aml_accepted_order_id: nil
      AML::OrderDocument.delete_all
      AML::Order.delete_all

      flash.alert = 'Заявки сброшены'
      redirect_to root_path
    end

    private

    def document_kinds
      @document_kinds ||= AML::DocumentKind.alive.ordered
    end

    def humanized_error(exception)
      Rails.logger.error exception
      Bugsnag.notify exception
      render 'humanized_error', status: 500, layout: 'simple', locals: { exception: exception }
    end

    def not_authenticated
      render 'not_authenticated', layout: 'simple'
    end

    def rescue_invalid_authenticity_token
      flash.alert = 'Просрочен токен аутентификации, авторизуйтесь снова'
      render 'not_authenticated', layout: 'simple'
    end

    def current_time_zone
      current_user.try(:time_zone) || Time.zone
    end
  end
end
