# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :user_id, :long_url, :short_url, presence: true

  def self.create!(user, url)
    code = self.random_code
    ShortenedUrl.new(:user_id => user.id, :long_url => url, :short_url => code)
  end

  def self.random_code
    code = nil
    until code && !ShortenedUrl.exists?(:short_url => code) do
        code = SecureRandom.urlsafe_base64
    end
    code
  end

  def num_clicks
    self.visits.select(:user_id).count
  end

  def num_uniques
    self.visits.select(:user_id).distinct.count
  end

  def num_recent_uniques
  end

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :url_id

  has_many :visitors,
    through: :visits,
    source: :user
end
