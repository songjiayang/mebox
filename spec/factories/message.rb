require 'randexp'

FactoryGirl.define do
  factory :message do
    sender_id 1
    reciver_id 2
    content Randexp.name
  end
end
