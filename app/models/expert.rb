class Expert < ActiveRecord::Base
	validates :email, :uniqueness => true
	
	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
     :default_url => ":rails_root/public/system/avatars/:style/missing.png",
     :url  => ":rails_root/app/assets/images/:id/:style_:filename",
     :path => ":rails_root/app/assets/images/:id/:style_:filename"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  	validates :avatar, :attachment_presence => true, if: :featured?
	  validates_with AttachmentPresenceValidator, :attributes => :avatar, if: :featured?
	  validates_with AttachmentSizeValidator, :attributes => :avatar, :less_than => 1.megabytes, if: :featured?

  	# Validate filename
  	validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpeg\Z/]

end
