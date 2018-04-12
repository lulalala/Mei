class PostCell < Cell::Rails
  helper ApplicationHelper

  def show(post)
    @post = post
    @board = @post.topic.board
    render
  end

  def form(topic)
    return if topic.locked?

    @post_form = PostForm.new.from_topic(topic)
    render
  end

  def image_upload_control(form_field)
    @form_field = form_field
    render
  end

  def images(post)
    @images = post.images.where(remote_url: nil)
    render if @images.size > 0
  end
end
