class Visit < ApplicationRecord
  validates :user_id, :url_id, presence: true

  def self.record_visit!(user, short_url)
    Visit.new(:user_id => user.id, :url_id => short_url.id)
  end

  belongs_to :user,
    class_name: 'User',
    foreign_key: :user_id

  belongs_to :shortened_url,
    class_name: 'ShortenedUrl',
    foreign_key: :url_id
    
end
