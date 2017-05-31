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

require 'rails_helper'

RSpec.describe User, type: :model do
  context "attributes" do
    it { should respond_to :name }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
  end

  context "validates" do
    subject { User.new(name: "test") }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

  it "should work" do
    expect {
      create :user
    }.to change{User.count}.by(1)
  end

  it "should authenticate" do
    user = create :user
    expect(user.authenticate(user.password)).to be user
    expect(user.authenticate("invalid password")).to be false
  end
end
