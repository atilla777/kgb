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

ActiveRecord::Schema.define(version: 20160302182833) do

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

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name"

  create_table "scanned_ports", force: :cascade do |t|
    t.datetime "job_time"
    t.integer  "organization_id"
    t.string   "host_ip"
    t.integer  "number"
    t.string   "protocol"
    t.string   "state"
    t.string   "service"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "scanned_ports", ["host_ip"], name: "index_scanned_ports_on_host_ip"
  add_index "scanned_ports", ["number"], name: "index_scanned_ports_on_number"
  add_index "scanned_ports", ["organization_id"], name: "index_scanned_ports_on_organization_id"
  add_index "scanned_ports", ["protocol"], name: "index_scanned_ports_on_protocol"
  add_index "scanned_ports", ["service"], name: "index_scanned_ports_on_service"
  add_index "scanned_ports", ["state"], name: "index_scanned_ports_on_state"

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

end
