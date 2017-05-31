require 'rails_helper'

RSpec.describe SignIn, type: :model do
  context "attributes" do
    it { should respond_to :name }
    it { should respond_to :password }
  end

  context "authenticate!" do
    before do
      @user = create :user
    end

    it "should be true" do
      signup = SignIn.new(name: @user.name, password: @user.password)
      expect(signup.authenticate!).to be true
    end

    it "should be false if user not exist" do
      signup = SignIn.new(name: "invalid user", password: @user.name)
      expect(signup.authenticate!).to be false
      expect(signup.errors).to include "No such user"
    end

    it "should be false if invalid password" do
      signup = SignIn.new(name: @user.name, password: "invalid password")
      expect(signup.authenticate!).to be false
      expect(signup.errors).to include "Invalid password"
    end
  end
end
