# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_17_190457) do

  create_table "aml_agreement_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_agreement_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "details"
    t.index ["aml_agreement_id"], name: "index_aml_agreement_translations_on_aml_agreement_id"
    t.index ["locale"], name: "index_aml_agreement_translations_on_locale"
  end

  create_table "aml_agreements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.timestamp "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aml_check_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "url"
    t.integer "position", default: 0, null: false
    t.timestamp "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_aml_check_lists_on_title", unique: true
  end

  create_table "aml_client_agreements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "aml_client_id", null: false
    t.bigint "aml_agreement_id", null: false
    t.string "remote_ip", null: false
    t.string "locale", null: false
    t.text "user_agent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aml_agreement_id"], name: "index_aml_client_agreements_on_aml_agreement_id"
    t.index ["aml_client_id", "aml_agreement_id"], name: "aml_client_agreements_idx", unique: true
    t.index ["aml_client_id"], name: "index_aml_client_agreements_on_aml_client_id"
  end

  create_table "aml_client_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "aml_client_id", null: false
    t.string "first_name"
    t.string "maiden_name"
    t.string "last_name"
    t.string "patronymic"
    t.date "birth_date"
    t.string "birth_place"
    t.string "gender"
    t.text "address"
    t.string "citizenship"
    t.string "passport_number"
    t.string "second_document_number"
    t.string "card_suffix"
    t.string "utility_bill"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aml_client_id"], name: "index_aml_client_infos_on_aml_client_id_uniq", unique: true
  end

  create_table "aml_clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "surname"
    t.string "patronymic"
    t.string "workflow_state", default: "none", null: false
    t.date "birth_date"
    t.bigint "aml_order_id"
    t.bigint "aml_status_id"
    t.bigint "aml_accepted_order_id"
    t.string "email"
    t.string "phone"
    t.integer "total_income_amount_cents", default: 0, null: false
    t.string "total_income_amount_currency", default: "eur", null: false
    t.integer "total_operations_count", default: 0, null: false
    t.string "risk_category", limit: 1
    t.string "locale"
    t.index ["aml_accepted_order_id"], name: "index_aml_clients_on_aml_accepted_order_id"
    t.index ["aml_order_id"], name: "index_aml_clients_on_aml_order_id"
    t.index ["aml_status_id"], name: "index_aml_clients_on_aml_status_id"
  end

  create_table "aml_document_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_document_id"
    t.bigint "document_kind_field_definition_id"
    t.index ["document_kind_field_definition_id"], name: "fk_rails_bd0e9183bb"
    t.index ["order_document_id", "document_kind_field_definition_id"], name: "client_document_fields_index", unique: true
  end

  create_table "aml_document_group_to_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "aml_document_group_id", null: false
    t.bigint "aml_status_id", null: false
    t.index ["aml_document_group_id", "aml_status_id"], name: "aml_dgts_uniq", unique: true
    t.index ["aml_document_group_id"], name: "index_aml_document_group_to_statuses_on_aml_document_group_id"
    t.index ["aml_status_id"], name: "index_aml_document_group_to_statuses_on_aml_status_id"
  end

  create_table "aml_document_group_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_document_group_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "details"
    t.index ["aml_document_group_id"], name: "index_aml_document_group_translations_on_aml_document_group_id"
    t.index ["locale"], name: "index_aml_document_group_translations_on_locale"
  end

  create_table "aml_document_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "position", null: false
    t.timestamp "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "card_required", default: false, null: false
  end

  create_table "aml_document_kind_field_definition_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_document_kind_field_definition_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["aml_document_kind_field_definition_id"], name: "index_8e19003e2816ab4bd953879a6d8a7e57de3ab446"
    t.index ["locale"], name: "index_aml_document_kind_field_definition_translations_on_locale"
  end

  create_table "aml_document_kind_field_definitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_kind_id"
    t.integer "position"
    t.index ["document_kind_id", "key"], name: "index_aml_document_kind_field_definitions_on_key", unique: true
  end

  create_table "aml_document_kind_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_document_kind_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "details"
    t.string "file_title"
    t.index ["aml_document_kind_id"], name: "index_aml_document_kind_translations_on_aml_document_kind_id"
    t.index ["locale"], name: "index_aml_document_kind_translations_on_locale"
  end

  create_table "aml_document_kinds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "archived_at"
    t.integer "position"
    t.bigint "aml_document_group_id"
    t.string "file"
    t.string "goal"
    t.index ["aml_document_group_id"], name: "index_aml_document_kinds_on_aml_document_group_id"
  end

  create_table "aml_notification_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "locale", null: false
    t.string "template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "aml_notification_id", default: 0
    t.index ["aml_notification_id", "locale"], name: "aml_notification_templates_uniq", unique: true
    t.index ["aml_notification_id"], name: "index_aml_notification_templates_on_aml_notification_id"
  end

  create_table "aml_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_aml_notifications_on_title", unique: true
  end

  create_table "aml_operators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "workflow_state", default: "unblocked", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "role", default: 0, null: false
    t.string "name", null: false
    t.string "locale", default: "ru", null: false
    t.string "time_zone_name"
    t.index ["email"], name: "index_aml_operators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_aml_operators_on_reset_password_token"
  end

  create_table "aml_order_checks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "aml_order_id", null: false
    t.bigint "aml_check_list_id", null: false
    t.string "workflow_state", default: "none", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aml_check_list_id"], name: "index_aml_order_checks_on_aml_check_list_id"
    t.index ["aml_order_id", "aml_check_list_id"], name: "index_aml_order_checks_on_aml_order_id_and_aml_check_list_id", unique: true
    t.index ["aml_order_id"], name: "index_aml_order_checks_on_aml_order_id"
  end

  create_table "aml_order_documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "document_kind_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "workflow_state", default: "none", null: false
    t.bigint "order_id"
    t.bigint "aml_reject_reason_id"
    t.text "reject_reason_details"
    t.index ["aml_reject_reason_id"], name: "index_aml_order_documents_on_aml_reject_reason_id"
    t.index ["document_kind_id"], name: "index_aml_order_documents_on_document_kind_id"
    t.index ["order_id", "document_kind_id"], name: "index_aml_order_documents_on_order_id_and_document_kind_id", unique: true
    t.index ["order_id"], name: "index_aml_order_documents_on_order_id"
  end

  create_table "aml_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "surname"
    t.string "patronymic"
    t.date "birth_date"
    t.string "workflow_state", default: "none", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.bigint "operator_id"
    t.timestamp "archived_at"
    t.bigint "aml_status_id", null: false
    t.bigint "aml_reject_reason_id"
    t.text "reject_reason_details"
    t.timestamp "pending_at"
    t.timestamp "operated_at"
    t.string "card_brand"
    t.string "card_bin"
    t.string "card_suffix"
    t.bigint "cloned_order_id"
    t.string "card_holding_state", default: "none", null: false
    t.timestamp "card_holding_state_updated_at"
    t.index ["aml_reject_reason_id"], name: "index_aml_orders_on_aml_reject_reason_id"
    t.index ["aml_status_id"], name: "index_aml_orders_on_aml_status_id"
    t.index ["client_id"], name: "index_aml_orders_on_client_id"
    t.index ["cloned_order_id"], name: "index_aml_orders_on_cloned_order_id"
    t.index ["operator_id"], name: "index_aml_orders_on_operator_id"
    t.index ["workflow_state", "operated_at"], name: "index_aml_orders_on_workflow_state_and_operated_at"
    t.index ["workflow_state", "pending_at"], name: "index_aml_orders_on_workflow_state_and_pending_at"
  end

  create_table "aml_payment_card_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "card_brand"
    t.string "card_bin"
    t.string "card_suffix"
    t.string "image"
    t.string "workflow_state", default: "none", null: false
    t.integer "aml_reject_reason_id"
    t.string "reject_reason_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "aml_client_id"
    t.bigint "aml_operator_id"
    t.timestamp "pending_at"
    t.timestamp "operated_at"
    t.bigint "on_pending_notification_id"
    t.bigint "on_accept_notification_id"
    t.bigint "on_reject_notification_id"
    t.index ["aml_client_id"], name: "index_aml_payment_card_orders_on_aml_client_id"
    t.index ["aml_operator_id"], name: "index_aml_payment_card_orders_on_aml_operator_id"
    t.index ["on_accept_notification_id"], name: "index_aml_payment_card_orders_on_on_accept_notification_id"
    t.index ["on_pending_notification_id"], name: "index_aml_payment_card_orders_on_on_pending_notification_id"
    t.index ["on_reject_notification_id"], name: "index_aml_payment_card_orders_on_on_reject_notification_id"
    t.index ["workflow_state", "operated_at"], name: "index_aml_payment_card_orders_on_workflow_state_and_operated_at"
    t.index ["workflow_state", "pending_at"], name: "index_aml_payment_card_orders_on_workflow_state_and_pending_at"
  end

  create_table "aml_payment_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "card_brand", null: false
    t.string "card_bin", limit: 6, null: false
    t.string "card_suffix", limit: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "aml_client_id"
    t.bigint "aml_payment_card_order_id"
    t.index ["aml_client_id", "card_bin", "card_suffix", "card_brand"], name: "client_bin_suffix_brand", unique: true
    t.index ["aml_client_id"], name: "index_aml_payment_cards_on_aml_client_id"
    t.index ["aml_payment_card_order_id"], name: "index_aml_payment_cards_on_aml_payment_card_order_id"
  end

  create_table "aml_reject_reason_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_reject_reason_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["aml_reject_reason_id"], name: "index_aml_reject_reason_translations_on_aml_reject_reason_id"
    t.index ["locale"], name: "index_aml_reject_reason_translations_on_locale"
  end

  create_table "aml_reject_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.timestamp "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", null: false
  end

  create_table "aml_status_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "aml_status_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "details"
    t.index ["aml_status_id"], name: "index_aml_status_translations_on_aml_status_id"
    t.index ["locale"], name: "index_aml_status_translations_on_locale"
  end

  create_table "aml_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.timestamp "archived_at"
    t.string "key", null: false
    t.integer "max_amount_limit_cents", default: 0, null: false
    t.string "max_amount_limit_currency", default: "EUR", null: false
    t.integer "operations_count_limit", default: 0, null: false
    t.boolean "referal_output_enabled", default: false, null: false
    t.bigint "on_pending_notification_id"
    t.bigint "on_accept_notification_id"
    t.bigint "on_reject_notification_id"
    t.index ["key"], name: "index_aml_statuses_on_key", unique: true
    t.index ["on_accept_notification_id"], name: "index_aml_statuses_on_on_accept_notification_id"
    t.index ["on_pending_notification_id"], name: "index_aml_statuses_on_on_pending_notification_id"
    t.index ["on_reject_notification_id"], name: "index_aml_statuses_on_on_reject_notification_id"
  end

  add_foreign_key "aml_client_agreements", "aml_agreements"
  add_foreign_key "aml_client_agreements", "aml_clients"
  add_foreign_key "aml_client_infos", "aml_clients"
  add_foreign_key "aml_clients", "aml_orders", column: "aml_accepted_order_id"
  add_foreign_key "aml_clients", "aml_orders", on_delete: :nullify
  add_foreign_key "aml_clients", "aml_statuses"
  add_foreign_key "aml_document_fields", "aml_document_kind_field_definitions", column: "document_kind_field_definition_id"
  add_foreign_key "aml_document_fields", "aml_order_documents", column: "order_document_id"
  add_foreign_key "aml_document_group_to_statuses", "aml_document_groups"
  add_foreign_key "aml_document_group_to_statuses", "aml_statuses"
  add_foreign_key "aml_document_kind_field_definitions", "aml_document_kinds", column: "document_kind_id"
  add_foreign_key "aml_order_checks", "aml_check_lists"
  add_foreign_key "aml_order_checks", "aml_orders"
  add_foreign_key "aml_order_documents", "aml_document_kinds", column: "document_kind_id"
  add_foreign_key "aml_order_documents", "aml_orders", column: "order_id"
  add_foreign_key "aml_orders", "aml_clients", column: "client_id"
  add_foreign_key "aml_orders", "aml_operators", column: "operator_id"
  add_foreign_key "aml_orders", "aml_orders", column: "cloned_order_id"
  add_foreign_key "aml_orders", "aml_statuses"
  add_foreign_key "aml_payment_card_orders", "aml_notifications", column: "on_accept_notification_id"
  add_foreign_key "aml_payment_card_orders", "aml_notifications", column: "on_pending_notification_id"
  add_foreign_key "aml_payment_card_orders", "aml_notifications", column: "on_reject_notification_id"
  add_foreign_key "aml_statuses", "aml_notifications", column: "on_accept_notification_id"
  add_foreign_key "aml_statuses", "aml_notifications", column: "on_pending_notification_id"
  add_foreign_key "aml_statuses", "aml_notifications", column: "on_reject_notification_id"
end
