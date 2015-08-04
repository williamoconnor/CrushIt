class Article < ActiveRecord::Base
	has_attached_file :text_file,
     :default_url => ":rails_root/public/system/avatars/:style/missing.png",
     :url  => ":rails_root/articles/:filename",
     :path => ":rails_root/articles/:filename"
  	validates_attachment_content_type :text_file, :content_type => 'text/plain'

  	validates :text_file, :attachment_presence => true
	  validates_with AttachmentPresenceValidator, :attributes => :text_file
	  validates_with AttachmentSizeValidator, :attributes => :text_file, :less_than => 1.megabytes

  	# Validate filename
  	# validates_attachment_file_name :text_file, :matches => /txt\Z/

  	validates :name, :uniqueness => true

end
