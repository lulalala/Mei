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

ActiveRecord::Schema.define(version: 20170523114957) do

  create_table "boards", force: :cascade, comment: "board" do |t|
    t.string   "seo_name",   limit: 255,   null: false, comment: "represent name in URL. Must be URL valid characters."
    t.string   "name",       limit: 255,   null: false, comment: "display name on top of page"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "config",     limit: 65535,              comment: "board-specific configuration in YAML"
  end

  add_index "boards", ["seo_name"], name: "index_boards_on_seo_name", unique: true, using: :btree

  create_table "images", force: :cascade, comment: "image" do |t|
    t.integer  "post_id",      limit: 4
    t.string   "image",        limit: 255,              comment: "filename"
    t.integer  "width",        limit: 4
    t.integer  "height",       limit: 4
    t.integer  "thumb_width",  limit: 4
    t.integer  "thumb_height", limit: 4
    t.string   "remote_url",   limit: 255,              comment: "url of image fetched from"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "images", ["post_id"], name: "index_images_on_post_id", using: :btree
  add_index "images", ["remote_url"], name: "index_images_on_remote_url", using: :btree

  create_table "posts", force: :cascade, comment: "text content posted. New post or reply comments are all posts." do |t|
    t.text     "content",      limit: 65535,              comment: "text content"
    t.string   "author",       limit: 255,                comment: "author name"
    t.string   "options",      limit: 255,                comment: "array of options like sage"
    t.string   "options_raw",  limit: 255,                comment: "user input for email and options"
    t.string   "email",        limit: 255,                comment: "email"
    t.integer  "topic_id",     limit: 4,     null: false
    t.integer  "pos",          limit: 2,     null: false, comment: "position of post within topic"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "content_html", limit: 65535,              comment: "text content processed into html"
  end

  add_index "posts", ["topic_id", "pos"], name: "index_posts_on_topic_id_and_pos", unique: true, using: :btree
  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id", using: :btree

  create_table "replies", force: :cascade, comment: "replying relations between posts" do |t|
    t.integer "ancestor_id",   limit: 4, comment: "post that is being replied to"
    t.integer "descendant_id", limit: 4, comment: "post that is the reply"
  end

  create_table "topics", force: :cascade, comment: "topic of discussion, also called thread" do |t|
    t.string   "title",           limit: 255,                              comment: "title"
    t.integer  "board_id",        limit: 4,                   null: false
    t.integer  "max_pos",         limit: 2,   default: 0,     null: false, comment: "current newest post pos, increment as posts are created"
    t.boolean  "locked",                      default: false, null: false, comment: "prevent further replies"
    t.boolean  "file_attachable",             default: true,  null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "bumped_at",                                                comment: "topic bump time"
  end

  add_index "topics", ["board_id"], name: "index_topics_on_board_id", using: :btree

  create_table "view_fragments", force: :cascade, comment: "Custom HTML fragments to be displayed" do |t|
    t.integer  "board_id",   limit: 4
    t.string   "name",       limit: 255,   null: false, comment: "name for referencing"
    t.text     "content",    limit: 65535,              comment: "html fragment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "view_fragments", ["board_id", "name"], name: "index_view_fragments_on_board_id_and_name", unique: true, using: :btree

  add_foreign_key "images", "posts"
  add_foreign_key "posts", "topics"
  add_foreign_key "topics", "boards"
  add_foreign_key "view_fragments", "boards"
end
