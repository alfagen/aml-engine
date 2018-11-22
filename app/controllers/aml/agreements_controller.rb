require_relative 'application_controller'

module AML
  class AgreementsController < ApplicationController
    authorize_actions_for AML::Agreement

    def index
      render locals: { agreements: AML::Agreement.alive.ordered }
    end

    def new
      render locals: { agreement: AML::Agreement.new }
    end

    def create
      agreement = AML::Agreement.create! permitted_params
      redirect_to agreements_path, notice: "Соглашение создано ##{agreement.id}"
    rescue ActiveRecord::RecordInvalid => err
      render :new, locals: { agreement: err.record }, alert: err.message
    end

    def edit
      render locals: { agreement: agreement }
    end

    def show
      redirect_to edit_agreement_path agreement
    end

    def update
      agreement.update! permitted_params
      redirect_to agreements_path, notice: "Соглашение обновлена ##{agreement.id}"
    rescue ActiveRecord::RecordInvalid => err
      render :edit, locals: { agreement: err.record }, alert: err.message
    end

    def destroy
      agreement.destroy!
      redirect_to agreements_path, notice: "Соглашение удалена ##{agreement}"
    end

    private

    def agreement
      @agreement ||= AML::Agreement.find(params[:id])
    end

    def permitted_params
      params.require(:agreement).permit!
    end
  end
end
