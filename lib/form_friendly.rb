module FormFriendly
  def self.included clazz
    clazz.extend ActiveModel::Naming
    clazz.send :include, ActiveModel::Conversion
    clazz.send :include, NotPersisted
  end

  module NotPersisted
    def persisted?
      false
    end
  end
end