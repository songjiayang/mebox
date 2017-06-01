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

require 'rails_helper'

RSpec.describe Contact, type: :model do
  context "attributes" do
    it { should respond_to :user_id }
    it { should respond_to :contacted_id }
    it { should respond_to :new_message }
  end

  context "validates" do
    subject { Contact.new(user_id: 1, contacted_id: 2) }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :contacted_id }
    it { should validate_uniqueness_of(:user_id).scoped_to(:contacted_id) }
  end

  context "relationship"  do
    it { should belong_to :user }
    it { should belong_to :contacted_user }
  end

  it "should work" do
    expect {
      create :contact
    }.to change{ Contact.count }.by(1)
  end
end
