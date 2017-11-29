require 'topic/reply'

class PostForm
  include ActiveModel::Model

  attr_accessor :topic, :post
  delegate :title, :board_id, :file_attachable?, to: :topic
  delegate :author, :content, :options_raw, :topic_id, :images, :images_attributes=, to: :post

  # To be called right after new().
  # For rendering empty form.
  def from_topic(topic)
    @topic = topic
    setup_post
    self
  end

  # To be called right after new().
  # For params submitted from user.
  def from_params(params)
    if params[:topic_id].present?
      @topic = Topic.find(params[:topic_id])

      @post = Topic::Reply.run!(
        topic: @topic,
        author: params[:author],
        content: params[:content],
        options_raw: params[:options_raw],
        images: build_images_from_params(params)
      )
    else
      @topic = Board.find(params[:board_id]).topics.build
      @post = @topic.posts.build
      attributes(params)
    end

    self
  end

  def setup_post
    @post = @topic.posts.build
    if @post.images.empty?
      @post.images.build
    end
  end

  def attributes(params)
    @post.assign_attributes(post_params(params))

    @post.images.concat build_images_from_params(params)

    if new_topic?
      if params[:title]
        @topic.title = params[:title]
      end
      if params[:board_id]
        @topic.board_id = params[:board_id]
      end
    end
  end

  def build_images_from_params(params)
    images = []

    if params[:image_ids].present?
      images.concat Image.where(id: params[:image_ids], post_id: nil)
    end

    if params[:images].present?
      params[:images].each do |file|
        images << Image.new(image:file)
      end
    end

    images
  end

  def valid?
    validity = true
    errors.clear
    [post, topic].each do |object|
      if !object.valid?
        validity = false
        object.errors.each do |key, values|
          errors[key] = values
        end
      end
    end
    validity
  end

  def new_topic?
    !@topic.persisted?
  end

  def save
    return false if !valid?

    ActiveRecord::Base.transaction do
      @post.save! if @post.changed?
      @topic.save! if new_topic?
    end

    true
  rescue ActiveRecord::RecordInvalid => invalid
    false
  end

  def post_params(params)
    params.permit(:author, :content, :options_raw, :topic_id)
  end

  # Necessary code

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Post')
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end
end

