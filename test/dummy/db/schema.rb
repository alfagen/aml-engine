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

ActiveRecord::Schema.define(version: 2018_08_27_112418) do
  create_table "aml_client_document_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_document_id"
    t.bigint "document_kind_field_definition_id"
    t.index ["document_kind_field_definition_id"], name: "fk_rails_bd0e9183bb"
    t.index ["order_document_id", "document_kind_field_definition_id"], name: "client_document_fields_index", unique: true
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
    t.index ["aml_order_id"], name: "index_aml_clients_on_aml_order_id"
  end

  create_table "aml_document_kind_field_definitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "title", null: false
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_kind_id"
    t.integer "position"
    t.index ["document_kind_id", "key"], name: "index_aml_document_kind_field_definitions_on_key", unique: true
  end

  create_table "aml_document_kinds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.timestamp "archived_at"
    t.text "details"
    t.integer "position"
    t.index ["title"], name: "index_aml_document_kinds_on_title", unique: true
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
    t.index ["email"], name: "index_aml_operators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_aml_operators_on_reset_password_token"
  end

  create_table "aml_order_documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "document_kind_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "workflow_state", default: "pending", null: false
    t.bigint "order_id"
    t.index ["document_kind_id"], name: "index_aml_order_documents_on_document_kind_id"
    t.index ["order_id", "document_kind_id"], name: "index_aml_order_documents_on_order_id_and_document_kind_id", unique: true
    t.index ["order_id"], name: "index_aml_order_documents_on_order_id"
  end

  create_table "aml_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "surname"
    t.string "patronymic"
    t.datetime "birth_date"
    t.string "workflow_state", default: "none", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.bigint "operator_id"
    t.timestamp "archived_at"
    t.index ["client_id"], name: "index_aml_orders_on_client_id"
    t.index ["operator_id"], name: "index_aml_orders_on_operator_id"
  end

  add_foreign_key "aml_client_document_fields", "aml_document_kind_field_definitions", column: "document_kind_field_definition_id"
  add_foreign_key "aml_client_document_fields", "aml_order_documents", column: "order_document_id"
  add_foreign_key "aml_clients", "aml_orders", on_delete: :nullify
  add_foreign_key "aml_document_kind_field_definitions", "aml_document_kinds", column: "document_kind_id"
  add_foreign_key "aml_order_documents", "aml_document_kinds", column: "document_kind_id"
  add_foreign_key "aml_order_documents", "aml_orders", column: "order_id"
  add_foreign_key "aml_orders", "aml_clients", column: "client_id"
  add_foreign_key "aml_orders", "aml_operators", column: "operator_id"
end
