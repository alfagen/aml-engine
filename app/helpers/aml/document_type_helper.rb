# frozen_string_literal: true

# Стиль active для первоначального открытия на вкладке alive
#
module AML
  module DocumentTypeHelper
    def document_active_type(state)
      state == :alive ? :inclusive : :exact
    end
  end
end
