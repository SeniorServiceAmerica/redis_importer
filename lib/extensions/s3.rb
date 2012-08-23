module AWS
  module S3
    class S3Object
      
      def name
        self.key
      end

      def to_class_name
        self.key.gsub('.csv','').capitalize
      end

      def save_to(path)
        File.open(path,'w') do |file|
          S3Object.stream(self.key,self.bucket.name) do |chunk|
            file.write chunk
          end
        end
      end
    end
  end
end