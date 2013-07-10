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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130524102439) do

  create_table "agreements", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "version"
    t.boolean  "isactive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "candidate_skills", :force => true do |t|
    t.integer  "candidate_id"
    t.integer  "skill_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "candidate_takeoffs", :force => true do |t|
    t.integer  "candidate_id"
    t.integer  "takeoff_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "candidates", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "phone"
    t.string   "linkedin_url"
    t.string   "other_url"
    t.text     "resume"
    t.string   "resume_file"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "status"
    t.boolean  "featured"
    t.datetime "featured_date"
    t.string   "availability_status"
    t.text     "candidate_pitch"
    t.string   "background_image"
    t.string   "profile_image"
    t.string   "displayname"
    t.string   "one_liner"
    t.string   "quote"
    t.integer  "takeoff_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "job_role"
    t.string   "skill_tags"
    t.string   "location_tag"
    t.string   "location"
    t.boolean  "anonymous"
    t.text     "skill_set"
  end

  create_table "cmspages", :force => true do |t|
    t.string   "page"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emaillists", :force => true do |t|
    t.string   "email"
    t.string   "type"
    t.string   "ipaddress"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employer_agreements", :force => true do |t|
    t.integer  "employer_id"
    t.integer  "agreement_id"
    t.string   "ipaddress"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "employer_job_titles", :force => true do |t|
    t.integer  "employer_id"
    t.integer  "job_title_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "employer_skills", :force => true do |t|
    t.integer  "employer_id"
    t.integer  "skill_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employerdomains", :force => true do |t|
    t.string   "employer_domain"
    t.string   "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "employers", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "website"
    t.string   "about"
    t.string   "phone"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "source"
    t.string   "pitch"
    t.string   "companyname"
    t.string   "firstname"
    t.string   "lastname"
  end

  create_table "interviews", :force => true do |t|
    t.datetime "request_date"
    t.integer  "employer_id"
    t.integer  "candidate_id"
    t.string   "employer_pitch"
    t.string   "status"
    t.datetime "status_changed_on"
    t.string   "candidate_status"
    t.datetime "candidate_status_changed_on"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "takeoff_id"
  end

  create_table "job_titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "portfolios", :force => true do |t|
    t.integer  "candidate_id"
    t.string   "thumbnail_image"
    t.string   "slider_image"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "takeoffs", :force => true do |t|
    t.string   "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "sale_period"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
