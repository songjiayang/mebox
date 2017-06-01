require 'randexp'

FactoryGirl.define do
  factory :contact do
    user_id Random.rand(1000)
    contacted_id Randexp.name
  end
end
