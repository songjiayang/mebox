# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  sender_id  :integer          not null
#  reciver_id :integer          not null
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  validates :sender_id, :reciver_id, :content, presence: true

  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :reciver, foreign_key: :reciver_id, class_name: "User"
  scope :newest, -> { order("id desc") }
  scope :before, -> (id) { where("id < ?", id) }
  scope :for, -> (sid, rid) {
      where(
        "sender_id=? AND reciver_id =? OR sender_id=? AND reciver_id =?",
        sid, rid, rid, sid
      )}
end
