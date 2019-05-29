require 'openssl'

module Oplop
  class Random
    def initialize(seed)
      @seed = seed % 2147483647
      @seed += 2147483646 if @seed <= 0
    end

    def next
      @seed = @seed * 16807 % 2147483647
    end
  end

  class V2019
    def initialize(label, master)
      @label = label
      @master = master
    end

    def digest
      @digest ||= OpenSSL::KDF.pbkdf2_hmac(@master, salt: @label, iterations: 10, length: 20, hash: 'SHA256') 
    end

    def random
      # TODO: convert raw hash to integer (bytes)
      @random ||= Random.new(digest)
    end
  end
end
