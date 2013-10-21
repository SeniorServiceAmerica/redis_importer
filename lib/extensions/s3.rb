module AWS
  module S3
    # Methods extending the S3Object class provided by the aws-s3 gem.
    class S3Object
      alias_method :name, :key

      # Returns the class represented by the csv file.
      #  person.csv => Person
      def to_class_name
        self.key.gsub('.csv','').split('_').map { |word| word.capitalize}.join
      end

      # Copies the S3 Object to a local directory.
      #   save_to('tmp/file.csv')
      #   Copied files are in ISO-8859-1 encoding
      def save_to(path)
        File.open(path,'wb') do |file|
          S3Object.stream(self.key,self.bucket.name) do |chunk|
            file.write chunk
          end
        end
      end
    end
  end
end
