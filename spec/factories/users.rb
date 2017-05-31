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
  factory :user do
    name Randexp.name
    password /\w{10}/.gen
  end
end
