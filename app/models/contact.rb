# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  contacted_id :string(255)      not null
#  new_message  :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Contact < ActiveRecord::Base

  validates :contacted_id, presence: true
  validates :user_id, presence: true,
            uniqueness: { scope: :contacted_id }

  belongs_to :user
  belongs_to :contacted_user, foreign_key: :contacted_id, class_name: "User"

  scope :before, -> (id) { where("id < ?", id) }
  scope :newest, -> { order("id desc") }
  
end
