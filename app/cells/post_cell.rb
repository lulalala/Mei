class PostCell < Cell::Rails
  def show(post)
    @post = post
    render
  end
end