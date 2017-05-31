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

require 'randexp'

FactoryGirl.define do
  factory :contact do
    user_id Random.rand(1000)
    contacted_id Random.rand(1000)
  end
end
