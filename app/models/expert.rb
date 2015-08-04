class Expert < ActiveRecord::Base
	validates :email, :uniqueness => true
	
	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
     :default_url => ":rails_root/public/system/avatars/:style/missing.png",
     :url  => ":rails_root/app/assets/images/:id/:style_:filename",
     :path => ":rails_root/app/assets/images/:id/:style_:filename"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  	validates :avatar, :attachment_presence => true
	validates_with AttachmentPresenceValidator, :attributes => :avatar
	validates_with AttachmentSizeValidator, :attributes => :avatar, :less_than => 1.megabytes

  	# Validate filename
  	validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpeg\Z/]

end
