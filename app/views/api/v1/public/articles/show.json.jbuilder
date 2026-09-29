json.article do
  json.extract! @article, :title, :description, :category_id, :likes_count
  json.liked @article.liked_by?(visitor_token)
end
