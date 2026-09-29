json.like do
  json.likes_count @article.reload.likes_count
  json.liked @article.liked_by?(visitor_token)
end
