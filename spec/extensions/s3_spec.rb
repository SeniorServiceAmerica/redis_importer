require "spec_helper"
module AWS
  module S3
    describe S3Object do
      before(:each) do
        @s3 = S3Object.new
      end
      describe "to_class_name" do
        it "removes the .csv from the end of the name" do
          @s3.stub(:key).and_return('something.csv')
          @s3.to_class_name.should_not include('.csv')
        end
        it "capitalizes the name" do
          @s3.stub(:key).and_return('lowercase.csv')
          @s3.to_class_name.start_with?('l').should eq false
          @s3.to_class_name.start_with?('L').should eq true
        end
        it "converts snake_case to CamelCase" do
          @s3.stub(:key).and_return('multi_word_class.csv')
          @s3.to_class_name.should eq 'MultiWordClass'
        end
      end
    end
  end
end