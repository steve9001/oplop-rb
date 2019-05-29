<<-DOC
PBKDF2 password: master, salt: label, iterations: 10, length: 20, hash: sha256

URL safe base64 without padding, RFC 4648

use first 16 characters for base digest

convert digest to integer with network endianness

allowed symbols:
from https://www.owasp.org/index.php/Password_special_characters
excluding space, backslash, doublequote, singlequote, backtick
"!#$%&()*+,-./:;<=>?@[]^_{|}~"
DOC

require 'base64'
require 'openssl'

module Oplop
  UPPER = ('A'..'Z').to_a
  LOWER = ('a'..'z').to_a
  DIGIT = ('0'..'9').to_a
  SYMBOL = "!#$%&()*+,-./:;<=>?@[]^_{|}~".split("")
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
      @random ||= \
        begin
          seed = digest.unpack("N").first # network endian
          Random.new(seed)
      end
    end

    def password
      positions = []
      while positions.length < 4 do
        p = random.next % 16
        positions << p unless positions.include? p
      end
      digest[positions[0]] = UPPER[random.next % 26]
      digest[positions[1]] = LOWER[random.next % 26]
      digest[positions[2]] = DIGIT[random.next % 10]
      digest[positions[3]] = SYMBOL[random.next % SYMBOL.length]
      digest
    end
  end
end