# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160321175749) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "jobs", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "ports"
    t.text     "hosts"
    t.text     "options"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
    t.integer  "option_set_id"
  end

  add_index "jobs", ["option_set_id"], name: "index_jobs_on_option_set_id"
  add_index "jobs", ["organization_id"], name: "index_jobs_on_organization_id"

  create_table "option_sets", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.text     "options"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "scanned_ports", force: :cascade do |t|
    t.datetime "job_time"
    t.integer  "organization_id"
    t.string   "host"
    t.integer  "port"
    t.string   "protocol"
    t.string   "state"
    t.string   "service"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "job_id"
    t.integer  "legality"
    t.string   "product"
    t.string   "product_version"
    t.string   "product_extrainfo"
  end

  add_index "scanned_ports", ["host"], name: "index_scanned_ports_on_host"
  add_index "scanned_ports", ["job_id"], name: "index_scanned_ports_on_job_id"
  add_index "scanned_ports", ["legality"], name: "index_scanned_ports_on_legality"
  add_index "scanned_ports", ["organization_id"], name: "index_scanned_ports_on_organization_id"
  add_index "scanned_ports", ["port"], name: "index_scanned_ports_on_port"
  add_index "scanned_ports", ["product"], name: "index_scanned_ports_on_product"
  add_index "scanned_ports", ["product_extrainfo"], name: "index_scanned_ports_on_product_extrainfo"
  add_index "scanned_ports", ["product_version"], name: "index_scanned_ports_on_product_version"
  add_index "scanned_ports", ["protocol"], name: "index_scanned_ports_on_protocol"
  add_index "scanned_ports", ["service"], name: "index_scanned_ports_on_service"
  add_index "scanned_ports", ["state"], name: "index_scanned_ports_on_state"

  create_table "schedules", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "week_day"
    t.integer  "month_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["job_id"], name: "index_schedules_on_job_id"
  add_index "schedules", ["month_day"], name: "index_schedules_on_month_day"
  add_index "schedules", ["week_day"], name: "index_schedules_on_week_day"

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.integer  "legality"
    t.string   "host"
    t.integer  "port"
    t.string   "protocol"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "services", ["host"], name: "index_services_on_host"
  add_index "services", ["legality"], name: "index_services_on_legality"
  add_index "services", ["organization_id"], name: "index_services_on_organization_id"
  add_index "services", ["port"], name: "index_services_on_port"
  add_index "services", ["protocol"], name: "index_services_on_protocol"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "job"
    t.text     "description"
    t.integer  "organization_id"
    t.string   "department"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         default: 0,     null: false
    t.integer  "failed_login_count",  default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",              default: false
    t.boolean  "approved",            default: false
    t.boolean  "confirmed",           default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["organization_id"], name: "index_users_on_organization_id"

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
