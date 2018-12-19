module AML
  class CardBrandValidator < ActiveModel::Validator
    CARD_BRAND = %i(visa master mir)

    def validate(object)
      object.errors.add(options[:card_brand_attribute], message(object)) unless CARD_BRAND.include? card_brand(object, options)
    end

    private

    def message(object)
      "Недопустимое значение#{card_brand(object, options)}, может быть: #{CARD_BRAND.join(', ')}."
    end

    def card_brand(object, options)
      object.send(options[:card_brand_attribute]).downcase.to_sym
    end
  end
end
