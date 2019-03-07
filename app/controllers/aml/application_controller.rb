module AML
  class ApplicationController < ::ApplicationController
    # Подключены в core app
    # helper NotyFlash::ApplicationHelper
    # helper LocalizedRender::Engine.helpers
    layout 'aml_application'

    include Pagination
    rescue_from Workflow::Error, with: :handle_humanized_error

    prepend_before_action :require_login

    before_action :check_blocked

    helper_method :document_kinds, :current_operator

    ensure_authorization_performed except: %i[error reset_db drop_clients drop_orders]

    # TODO Вынести в UtilsController
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

    def check_blocked
      unless current_user.aml_operator
        flash.now.alert = "У вас (#{current_user.email}) нет доступа к AML"
        # NOTE из core app
        raise NotAuthenticated
      end

      if current_operator.blocked?
        flash.now.alert = 'Вы заблокированы'
        raise Authority::SecurityViolation.exception(current_user, nil, nil)
      end
    end

    def document_kinds
      @document_kinds ||= AML::DocumentKind.alive.ordered
    end

    def current_operator
      current_user.aml_operator || raise("aml_operator is not defined for user #{current_user.id}")
    end
  end
end
