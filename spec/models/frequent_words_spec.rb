# encoding: utf-8
require 'spec_helper'

describe FrequentWords do
  
  context "Validation" do

    it "should be valid with correct arguments" do
      FrequentWords.new(text: 'this is a test').should be_valid
    end

    it "should be invalid with empty 'text' argument" do
      fw = FrequentWords.new
      fw.should be_invalid
      fw.errors.get(:text).should match_array(["can't be blank"])
    end

    it "should raise error with not accepted argument" do
      expect {
        FrequentWords.new(wrong: 'argument')
      }.to raise_error(RuntimeError, "Invalid argument 'wrong' for FrequentWords")
    end

  end

  context "Execution" do
    
    context "with text='hello hello hello my my name is'" do
      it "should return correct result" do
        result = {
          "hello" => 3,
          "my" => 2,
          "name" => 1,
          "is" => 1
        }
        fw = FrequentWords.new(text: 'hello hello hello my my name is')
        fw.execute.should be_true
        fw.to_hash.should eq(result)
      end
    end

    context "with text='hello hello my my name name is is Eugene Eugene Grep'" do
      it "should return only 5 words" do
        result = {
          "hello" => 2,
          "my" => 2,
          "name" => 2,
          "is" => 2,
          "Eugene" => 2
        }
        fw = FrequentWords.new(text: 'hello hello my my name name is is Eugene Eugene Grep')
        fw.execute.should be_true
        fw.to_hash.should eq(result)
      end
    end

    context "with some crazy text" do
      it "should return correct result" do
        result = {
          "username"=>2,
          "hello"=>2,
          "email"=>2,
          "Viele"=>2,
          "Grüße"=>2
        }
        fw = FrequentWords.new(text: 'username username:hello1 email email: hello@example.com, comment: \'Viele Grüße Viele Grüße\'')
        fw.execute.should be_true
        fw.to_hash.should eq(result)
      end
    end

    context "with text='###'" do
      it "should return empty result" do
        result = {}
        fw = FrequentWords.new(text: '###')
        fw.execute.should be_true
        fw.to_hash.should eq(result)
      end
    end

    context "with text=''" do
      it "should return false" do
        fw = FrequentWords.new(text: '')
        fw.execute.should be_false
        fw.to_hash.should eq({ :errors=>{:text=>["can't be blank"]} })
      end
    end

    context "with scan pattern /[a-zA-Z]+/", focus: true do

      context "with some crazy text" do
        it "should return correct result" do
          result = {
            "username"=>2,
            "hello"=>2,
            "email"=>2,
            "example"=>1,
            "com"=>1
          }
          fw = FrequentWords.new(
            text: 'username username:hello1 email email: hello@example.com, comment: \'Пользователь\'',
            scan_for: /[a-zA-Z]+/
          )
          fw.execute.should be_true
          fw.to_hash.should eq(result)
        end
      end
    end

  end

end