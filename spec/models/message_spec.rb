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

require 'rails_helper'

RSpec.describe Message, type: :model do
  context "attributes" do
    it { should respond_to :sender_id }
    it { should respond_to :reciver_id }
    it { should respond_to :content }
  end

  context "validates" do
    it { should validate_presence_of :sender_id }
    it { should validate_presence_of :reciver_id }
    it { should validate_presence_of :content }
  end

  context "relationship"  do
    it { should belong_to :sender }
    it { should belong_to :reciver }
  end

  it "#scope" do
    expect(Message.newest.to_sql).to eq "SELECT `messages`.* FROM `messages`  ORDER BY id desc"
    expect(
      Message.for(1,2).to_sql
    ).to eq "SELECT `messages`.* FROM `messages` WHERE (sender_id=1 AND reciver_id =2 OR sender_id=2 AND reciver_id =1)"
  end

  it "should work" do
    expect {
      create :message
    }.to change{ Message.count }.by(1)
  end
end
