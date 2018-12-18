module AML
  class CardValidation < ActiveModel::Validator
    CARD_BIN = { visa: 6, master: 6, mir: 4 }
    CARD_SUFFIX = { visa: 4, master: 4, mir: 2 }

    def validate(object)
      if CARD_BIN[card_brand(object)]
        object.errors.add(:card_bin, message(object, CARD_BIN)) unless object.card_bin.to_s.length == CARD_BIN[card_brand(object)]
        object.errors.add(:card_suffix, message(object, CARD_SUFFIX)) unless object.card_suffix.to_s.length == CARD_SUFFIX[card_brand(object)]
      else
        object.errors.add(:card_brand, "Тип карты отсутствует, допустимы #{card_list}")
      end
    end

    private

    def message(object, field)
      "Для #{object.card_brand} должны присутствовать #{field[card_brand(object)]} цифр"
    end

    def card_list
      CARD_BIN.keys.join(', ').upcase
    end

    def card_brand(object)
      object.card_brand.downcase.to_sym
    end
  end
end
