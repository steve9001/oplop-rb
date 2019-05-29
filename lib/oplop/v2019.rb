<<-DOC
PBKDF2 password: master, salt: label, iterations: 10, length: 20, hash: sha256

URL safe base64 without padding, RFC 4648

use first 16 characters for base digest

convert digest to integer with network endianness

DOC

require 'base64'
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
      #@digest ||= Base64.urlsafe_encode64(OpenSSL::KDF.pbkdf2_hmac(@master, salt: @label, iterations: 10, length: 20, hash: 'SHA256'), padding: false)
      @digest ||= \
        begin
          key = OpenSSL::KDF.pbkdf2_hmac(@master, salt: @label, iterations: 10, length: 20, hash: 'SHA256')
          encoded = Base64.urlsafe_encode64(key, padding: false)
          encoded[0..15]
      end
    end

    def random
      # TODO: convert raw hash to integer (bytes)
      @random ||= \
        begin
          seed = digest.unpack("N") # network endian
          Random.new(seed)
      end
    end

    def password
    end
  end
end
