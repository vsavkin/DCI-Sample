module ObjectMother
  extend self

  def create_user params = {}
    creation_params = params.reverse_merge(email: 'login@example.com', password: 'password')
    User.new(creation_params).tap{|user| user.save(validate: false)}
  end
end