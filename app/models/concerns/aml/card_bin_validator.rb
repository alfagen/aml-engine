module AML
  class CardBinValidator < ActiveModel::Validator
    CARD_BIN = { visa: 6, master: 6, mir: 4 }

    def validate(object)
      object.errors.add(options[:attributes].first, message(object)) unless object.send(options[:attributes].first).length == CARD_BIN[card_brand(object)]
    end

    private

    def message(object)
      "Для #{card_brand(object)} должны присутствовать #{CARD_BIN[card_brand(object)]} цифр" if CARD_BIN[card_brand(object)]
    end

    def card_brand(object)
      object.send(options[:card_brand_attribute]).downcase.to_sym
    end
  end
end
