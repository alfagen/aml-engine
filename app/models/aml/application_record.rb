module AML
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # Возвращает список событий которые доступны для данного состояния
    #
    # @param [Symbol]       Состояние
    #
    # @return Array[Symbol] Список событий
    #
    def available_workflow_events_for_state(state)
      state_spec = self.class.workflow_spec.states[state.to_sym]
      raise "Unknown state '#{state}'" if state_spec.nil?

      state_spec.events.select do |key, spec|
        condition_applicable? self
      end
    end

    # Возвращает список доступных событий для текущего состояния
    #

    def enabled_workflow_events
      current_state.events.map { |k, events| events.select { |e| e.condition_applicable? self } }.flatten.uniq.map(&:name)
    end
  end
end
