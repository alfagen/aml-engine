class Setup < ActiveRecord::Migration[5.2]
  def change
    create_table "aml_client_document_fields", force: :cascade do |t|
      t.string "value"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "client_document_id"
      t.bigint "document_kind_field_definition_id"
      t.index ["client_document_id", "document_kind_field_definition_id"], name: "client_document_fields_index", unique: true
    end

    create_table "aml_client_documents", force: :cascade do |t|
      t.bigint "document_kind_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "image", null: false
      t.string "workflow_state", default: "pending", null: false
      t.bigint "order_id"
      t.index ["document_kind_id"], name: "index_aml_client_documents_on_document_kind_id"
      t.index ["order_id"], name: "index_aml_client_documents_on_order_id"
    end

    create_table "aml_clients", force: :cascade do |t|
      t.string "name", null: false
      t.string "inn", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "aml_document_kind_field_definitions", force: :cascade do |t|
      t.string "key", null: false
      t.string "title", null: false
      t.datetime "archived_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "document_kind_id"
      t.index ["document_kind_id", "key"], name: "index_aml_document_kind_field_definitions_on_key", unique: true
    end

    create_table "aml_document_kinds", force: :cascade do |t|
      t.string "title", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["title"], name: "index_aml_document_kinds_on_title", unique: true
    end

    create_table "aml_orders", force: :cascade do |t|
      t.string "first_name", null: false
      t.string "surname", null: false
      t.string "patronymic", null: false
      t.datetime "birth_date", null: false
      t.string "workflow_state", default: "none", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "client_id"
      t.bigint "user_id"
      t.index ["client_id"], name: "index_aml_orders_on_client_id"
      t.index ["user_id"], name: "index_aml_orders_on_user_id"
    end

    create_table "aml_users", force: :cascade do |t|
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
      t.index ["email"], name: "index_aml_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_aml_users_on_reset_password_token"
    end

    add_foreign_key "aml_client_document_fields", "aml_client_documents", column: "client_document_id"
    add_foreign_key "aml_client_document_fields", "aml_document_kind_field_definitions", column: "document_kind_field_definition_id"
    add_foreign_key "aml_client_documents", "aml_document_kinds", column: "document_kind_id"
    add_foreign_key "aml_client_documents", "aml_orders", column: "order_id"
    add_foreign_key "aml_document_kind_field_definitions", "aml_document_kinds", column: "document_kind_id"
    add_foreign_key "aml_orders", "aml_clients", column: "client_id"
    add_foreign_key "aml_orders", "aml_users", column: "user_id"
  end
end
