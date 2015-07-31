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
	  		chat = EndedChat.find(ratingParams[:ended_chat_id])
	        chat.rating = ratingParams[:rating]

	        expert = Expert.find(chat.expert_id)
	        rating = expert.rating * expert.total_rating
	        rating += ratingParams[:rating]
	        expert.total_rating += 1
	        expert.rating = rating/expert.total_rating
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
			params.require(:chat).permit(:expert_id, :user_id, :rating)
		end

		def ratingParams
			params.require(:rating).permit(:ended_chat_id, :rating)
		end
end
