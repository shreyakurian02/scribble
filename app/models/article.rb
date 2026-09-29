# frozen_string_literal: true

class Article < ApplicationRecord
  include Versionable
  include Sluggable

  scope :search_by_term_in_title_and_description, ->(search) {
 where("description ILIKE :search OR title ILIKE :search", search: "%#{search}%") }

  MAXIMUM_TITLE_LENGTH = 80

  enum :status, { draft: "draft", published: "published" }, default: "draft"

  belongs_to :category, counter_cache: true
  belongs_to :user

  has_many :article_schedules, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :publish_schedule, -> { publish }, class_name: "ArticleSchedule", dependent: :destroy
  has_one :unpublish_schedule, -> { unpublish }, class_name: "ArticleSchedule", dependent: :destroy

  validates :description, presence: true
  validates :slug, uniqueness: true, allow_nil: true
  validate :slug_not_changed
  validates :title, presence: true, length: { maximum: MAXIMUM_TITLE_LENGTH },
    format: { with: Constants::ALPHANUMERIC_FORMAT_REGEX, message: I18n.t("errors.alphanumeric") }

  before_save :set_last_published_at

  accepts_nested_attributes_for :article_schedules, allow_destroy: true

  def matched_description_content(search_term)
    description.gsub(/<[^>]+>/, "").scan(/(?i)(#{search_term}(?:[^ ]* ){0,3})/).flatten
  end

  def liked_by?(visitor_token)
    visitor_token.present? && likes.exists?(visitor_token:)
  end

  private

    def set_last_published_at
      self.last_published_at = Time.zone.now() if status_changed? && published?
    end
end
