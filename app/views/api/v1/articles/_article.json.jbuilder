# frozen_string_literal: true

json.extract! article, :id, :title, :description, :last_published_at, :status, :slug, :views, :likes_count
json.author article.user.name
