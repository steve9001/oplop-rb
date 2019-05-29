require 'pry'
require 'spec_helper'

describe "Oplop" do
  describe "Oplop" do
    context "todo revisit this spec structure; matches the test data" do
      Yajl::Parser.new.parse(File.new(File.dirname(__FILE__) + "/testdata/v2019.json", 'r')).each do |data|
        specify data["why"] do
          v2019 = Oplop::V2019.new data["label"], data["master"]
          expect(v2019.digest).to eq data["digest"]
          expect(v2019.password).to eq data["password"]
        end
      end
    end
  end
end
