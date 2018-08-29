# Стиль active для первоначального открытия на вкладке none
#
module AML
  module OrderHelper
    def order_active_type(workflow_state)
      workflow_state == :none ? :inclusive : :exact
    end
  end
end
