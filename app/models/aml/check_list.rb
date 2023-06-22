module AML
  class CheckList < ApplicationRecord
    include Archivable
    include Authority::Abilities

    scope :ordered, -> { order :position }

    has_many :aml_order_checks, class_name: 'AML::OrderCheck', dependent: :destroy, foreign_key: :aml_check_list_id

    validates :title, presence: true, uniqueness: { case_sensitive: false }

    after_create :add_to_open_orders

    def to_s
      title
    end

    private

    def add_to_open_orders
      AML::Order.open.find_each do |o|
        o.order_checks.create! aml_check_list: self
      end
    end

    # Перед архивацией
    #def remove_from_open_orders
      #AML::Order.open.find_each do |o|
        #o.order_checks.where(aml_check_list_id: id).destroy_all
      #end
    #end
  end
end
