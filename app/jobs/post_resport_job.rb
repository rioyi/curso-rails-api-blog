class PostResportJob < ApplicationJob
  queue_as :default

  def perform(user_id, post_id)
    # Do something later
    # user -> report post -> email report
    user = User.find(user_id)
    post = Post.find(post_id)
    report = PostReport.generate(post)
  end
end
