# encoding: utf-8
require "spec_helper"

describe "Requesting frequent words" do
  
  context "with correct params" do

    it "should return correct result" do
      post frequent_words_path, text: "hello hello hello my my name is", format: :json
      expect(response).to be_success
      expect(response.body).to include({
        "hello" => 3,
        "my" => 2,
        "name" => 1,
        "is" => 1
      }.to_json)
    end

  end

  context "with incorrect params" do

    it "should return errors" do
      post frequent_words_path, text: "", format: :json
      expect(response.status).to eq(422)
      expect(response.body).to include({ :errors=>{:text=>["can't be blank"]} }.to_json)
    end

  end

end