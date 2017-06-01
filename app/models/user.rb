# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true, uniqueness: true

  has_many :contacts, dependent: :destroy
  has_many :send_messages, dependent: :destroy, foreign_key: :sender_id, class_name: "Message"

  def contact_with!(contacted_id)
    contact = self.contacts.find_by(contacted_id: contacted_id)
    new_record = false
    if contact.nil?
      contact = self.contacts.create(contacted_id: contacted_id)
      new_record = true
    end

    return contact, new_record
  end
end
