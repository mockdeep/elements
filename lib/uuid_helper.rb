module UUIDHelper

  def self.included(base)
    base.class_eval do
      set_primary_key :id
      attr_readonly :id
      before_create :set_uuid

      private

      def set_uuid
        self.id = UUIDTools::UUID.random_create.to_s
      end
    end
  end

end
