# frozen_string_literal: true

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
