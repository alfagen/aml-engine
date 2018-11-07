module UserAgreementSupport
  extend ActiveSupport::Concern
  included do
    attr_accessor :agreement_ids

    after_create :create_agreements
  end

  private

  def create_agreements
    Array(agreement_ids).each do |id|
      user_agreements.create!(
        agreement_id: id,
        remote_ip:    last_ip,
        user_agent:   user_agent,
        locale:       I18n.locale)
    end
  end
end
