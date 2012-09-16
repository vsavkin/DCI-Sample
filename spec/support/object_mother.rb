module ObjectMother
  extend self

  def create_user params = {}
    n = Random.new.rand(10000)
    creation_params = params.reverse_merge(email: "login#{n}@example.com")

    User.new(creation_params).tap do |u|
      u.password = params.fetch(:password, "password123") if u.respond_to? :password
      u.save(validate: false)
    end
  end

  def create_auction params = {}
    creation_params = params.reverse_merge(status: Auction::STARTED,
                                           end_date: DateTime.current + 1.day,
                                           buy_it_now_price: 10)
    Auction.create!(creation_params)
  end
end