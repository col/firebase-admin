module FirebaseAuth
  module Response
    def self.create(response_hash)
      data = response_hash.data.dup
      data.extend(self)
      data
    end

    attr_reader :pagination
  end
end
