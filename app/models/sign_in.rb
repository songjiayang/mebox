class SignIn
  attr_accessor :name, :password
  attr_reader :errors, :user

  def initialize(ops={})
    @errors = []
    @name = ops[:name]
    @password = ops[:password]
  end

  def authenticate!
    @user = User.find_by(name: @name)
    unless @user
      @errors << "No such user"
      return false
    end

    unless @user.try(:authenticate, @password)
      @errors << "Invalid password"
      return false
    end

    return true
  end
end
