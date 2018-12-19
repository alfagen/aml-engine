module AML
  class CardSuffixValidator < ActiveModel::Validator
    def validate(object)
      object.errors.add(options[:attributes].first, message(object)) unless object.send(options[:attributes].first).length == AML.card_suffix[card_brand(object)]
    end

    private

    def message(object)
      "Для #{card_brand(object)} должны присутствовать #{AML.card_suffix[card_brand(object)]} цифр" if AML.card_suffix[card_brand(object)]
    end

    def card_brand(object)
      object.send(options[:card_brand_attribute]).downcase.to_sym
    end
  end
end
