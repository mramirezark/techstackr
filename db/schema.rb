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

ActiveRecord::Schema[8.0].define(version: 2025_10_14_191303) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "migration_metadata", force: :cascade do |t|
    t.string "version", null: false
    t.string "description"
    t.string "migration_type", default: "versioned"
    t.string "script_name"
    t.string "checksum"
    t.string "installed_by"
    t.datetime "installed_at"
    t.integer "execution_time_ms"
    t.boolean "success", default: true
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installed_at"], name: "index_migration_metadata_on_installed_at"
    t.index ["version"], name: "index_migration_metadata_on_version", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "project_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "industry"
    t.integer "estimated_team_size"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.text "ai_response"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_recommendations_on_project_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "recommendation_id", null: false
    t.string "role"
    t.integer "count"
    t.text "skills"
    t.text "responsibilities"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recommendation_id"], name: "index_team_members_on_recommendation_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.bigint "recommendation_id", null: false
    t.string "name"
    t.string "category"
    t.text "description"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recommendation_id"], name: "index_technologies_on_recommendation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "projects", "users"
  add_foreign_key "recommendations", "projects"
  add_foreign_key "team_members", "recommendations"
  add_foreign_key "technologies", "recommendations"
end
