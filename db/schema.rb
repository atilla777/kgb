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

ActiveRecord::Schema.define(version: 20160228080223) do

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

end
