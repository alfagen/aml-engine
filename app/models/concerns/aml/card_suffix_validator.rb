module AML
  class CardSuffixValidator < ActiveModel::Validator
    CARD_SUFFIX = { visa: 4, master: 4, mir: 2 }

    def validate(object)
      object.errors.add(options.keys.first, message(object)) unless object.send(options.keys.first).length == CARD_SUFFIX[card_brand(object)]
    end

    private

    def message(object)
      "Для #{card_brand(object)} должны присутствовать #{CARD_SUFFIX[card_brand(object)]} цифр" if CARD_SUFFIX[card_brand(object)]
    end

    def card_brand(object)
      object.send(options[options.keys.first][:card_brand_attribute]).downcase.to_sym
    end
  end
end
