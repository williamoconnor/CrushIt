class EndedChatsController < ApplicationController
	def endChat
	  	if request.post?
	      # puts user_params
      	  chatData = endedChatParams
      	  if !chatData.rating
      	  	chatData.rating = -1
      	  end
  		  chat = EndedChat.new(chatData)
        # puts user 

  		  if chat.save
            render :json => chat.to_json, :status => 200
	      else
	          error_str = ""

	          chat.errors.each{|attr, msg|           
	            error_str += "#{attr} - #{msg},"
	          }
	          puts error_str
	                    
	          e = Error.new(:status => 400, :message => error_str)
	          render :json => e.to_json, :status => 400
	      end
	  	end
	end

	def submitRating
	  	if request.post?
	  		chat = EndedChat.find(ratingParams[:endedChatID])
	        chat.rating = ratingParams[:rating]

	        expert = Expert.find(chat.expertID)
	        rating = expert.rating * expert.totalRating
	        rating += ratingParams[:rating]
	        expert.totalRating += 1
	        expert.rating = rating/expert.totalRating
	        expert.correspondence += 1

	  		if chat.save && expert.save
	          render :json => chat.to_json, :status => 200
	        else
	          error_str = ""

	          chat.errors.each{|attr, msg|           
	            error_str += "#{attr} - #{msg},"
	          }
	          expert.errors.each{|attr, msg|           
	            error_str += "#{attr} - #{msg},"
	          }

	          puts error_str
	                    
	          e = Error.new(:status => 400, :message => error_str)
	          render :json => e.to_json, :status => 400
	        end
	  	end
	end

	private
		def endedChatParams
			params.require(:chat).permit(:expertID, :userID, :rating)
		end

		def ratingParams
			params.require(:rating).permit(:endedChatID, :rating)
		end
end
