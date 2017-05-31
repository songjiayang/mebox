class Contact < ActiveRecord::Base

  validates :contacted_id, presence: true
  validates :user_id, presence: true,
            uniqueness: { scope: :contacted_id }

  belongs_to :user
  belongs_to :contacted_user, foreign_key: :contacted_id, class_name: "User"

end
