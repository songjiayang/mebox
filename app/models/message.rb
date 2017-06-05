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

  attr_reader :notice_contact, :notice_contact_created
  after_create :check_reciver_contact

  private

  def check_reciver_contact
    @notice_contact, @notice_contact_created = self.reciver.contact_with!(self.sender.name)
    @notice_contact.new_message += 1
    @notice_contact.save
  end
end
