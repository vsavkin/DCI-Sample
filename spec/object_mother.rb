module ObjectMother
  extend self

  def create_user params
    User.new(params).tap{|user| user.save(validate: false)}
  end
end