class PostsSearchService
  def self.search(curr_posts, query)
    # {k => v}
    posts_ids = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hours) do
      curr_posts.where("title LIKE '%#{query}%' ").map(&:id)
    end

    curr_posts.where(id: posts_ids)
  end
end