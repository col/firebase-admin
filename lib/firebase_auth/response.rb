module FirebaseAuth
  module Response
    def self.create(response_hash)
      data = response_hash.dup
      data.extend(self)
      data
    end

    attr_reader :pagination
  end
end
