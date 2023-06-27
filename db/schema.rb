# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_25_070253) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "description", null: false
    t.datetime "last_published_at"
    t.string "status", default: "draft", null: false
    t.uuid "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.integer "views", default: 0, null: false
    t.index ["category_id"], name: "index_articles_on_category_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "articles_count", default: 0
    t.integer "position"
    t.uuid "site_id", null: false
    t.index ["site_id", "name"], name: "index_categories_on_site_id_and_name", unique: true
    t.index ["site_id"], name: "index_categories_on_site_id"
  end

  create_table "redirections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "from_path", null: false
    t.string "to_path", null: false
    t.uuid "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id", "from_path"], name: "index_redirections_on_site_id_and_from_path", unique: true
    t.index ["site_id"], name: "index_redirections_on_site_id"
  end

  create_table "sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", default: "Spinkart", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "authentication_token"
    t.index ["title"], name: "index_sites_on_title", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.citext "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "site_id", null: false
    t.index ["site_id", "email"], name: "index_users_on_site_id_and_email", unique: true
    t.index ["site_id"], name: "index_users_on_site_id"
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.string "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "articles", "categories"
  add_foreign_key "articles", "users", on_delete: :cascade
  add_foreign_key "categories", "sites", on_delete: :cascade
  add_foreign_key "redirections", "sites", on_delete: :cascade
  add_foreign_key "users", "sites", on_delete: :cascade
end
