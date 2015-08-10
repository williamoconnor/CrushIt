class ChatsController < ApplicationController
	def new
		@chat = Chat.new()
		@chat.user_id = params[:correspondence][:user_id]
		@chat.expert_id = params[:correspondence][:expert_id]
		@chat.renewals = 0
		@chat.active = true
		@chat.rating = 0
		@chat.dialog_id = ""

		@existingChat = Chat.where("active = ? AND user_id = ? AND expert_id = ?", true, @chat.user_id, @chat.expert_id)
		if !existingChat.blank?
			result = {"new" => false, "chat" => @chat}
			render :json => result.to_json, :status => 200
		else
			if @chat.save
				result = {"new" => true, "chat" => @chat}
				render :json => result.to_json, :status => 200
			else
			  error_str = ""

			  @chat.errors.each{|attr, msg|           
			    error_str += "#{attr} - #{msg},"
			  }
			  puts error_str
			            
			  @e = Error.new(:status => 400, :message => error_str)
			  render :json => @e.to_json, :status => 400
			end
		end
	end

	def endChat
		@chat = Chat.find(params[:chat_id])
		@chat.active = false
		@chat.pending_renewal = false

		@expert = Expert.where("id = ?", @chat.expert_id)
		@expert.correspondences += @chat.renewals + 1

		if @chat.save && @expert.save
			render :json => @chat.to_json, :status => 200
		else
			error_str = ""

			@chat.errors.each{|attr, msg|           
			error_str += "#{attr} - #{msg},"
			}
			puts error_str
			        
			@e = Error.new(:status => 400, :message => error_str)
			render :json => @e.to_json, :status => 400
		end
	end

	def submitRating
	  	if request.post?
	  		@chat = Chat.find(ratingParams[:chat_id])
	        @chat.rating = ratingParams[:rating]

	        expert = Expert.find(chat.expert_id)
	        rating = expert.rating * expert.total_rating
	        rating += ratingParams[:rating]
	        expert.total_rating += 1
	        expert.rating = rating/expert.total_rating
	        expert.correspondence += 1

	  		if @chat.save && expert.save
	          render :json => @chat.to_json, :status => 200
	        else
	          error_str = ""

	          @chat.errors.each{|attr, msg|           
	            error_str += "#{attr} - #{msg},"
	          }
	          expert.errors.each{|attr, msg|           
	            error_str += "#{attr} - #{msg},"
	          }

	          puts error_str
	                    
	          @e = Error.new(:status => 400, :message => error_str)
	          render :json => @e.to_json, :status => 400
	        end
	  	end
	end

	def userActiveChats
		@chats = Chat.where("user_id = ? AND active = ?", params[:user_id], true)
		@experts = Array.new
		@chats.each do |chat|
			expert_id = chat.expert_id
			expertInfo = Expert.find(expert_id)
			userInfo = User.where("expert_id = ?", expert_id).first
			expert = {"user" => userInfo, "expert" => expertInfo}
			@experts.push(expert)
		end
		if @chats && @experts
			result = {"chats" => @chats, "experts" => @experts}
			render :json => result.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def expertActiveChats
		@chats = Chat.where("expert_id = ? AND active = ?", params[:expert_id], true)
		@users = Array.new
		@chats.each do |chat|
			user_id = chat.user_id
			userInfo = User.find(user_id)
			@users.push(userInfo)
		end
		if @chats && @users
			result = {"chats" => @chats, "users" => @users}
			render :json => result.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def unratedInactiveChats
		@unratedChats = Chat.where("rating = ? AND active = ? AND user_id = ?", 0, false, params[:user_id])

		if @unratedChats.blank?
			result = {"empty" => true}
		else
			result = {"empty" => false, "chats" => @unratedChats}
		end
		render :json => result.to_json, :status => 200
	end

	def renewChatRequest
		@chat = Chat.find(params[:chatID])
		@chat.pendingRenewal = params[:setting]

  		if @chat.save
          render :json => @chat.to_json, :status => 200
        else
          error_str = ""

          @chat.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }

          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
        end
	end

	def renewChat
		@chat = Chat.find(params[:chatID])
		@chat.pendingRenewal = false
		@chat.renewals += 1 # manage payment and shit on the front end

  		if @chat.save
          render :json => @chat.to_json, :status => 200
        else
          error_str = ""

          chat.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }

          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
        end
	end

	def addDialogId
		@chat = Chat.find(params[:chatID])
		@chat.dialog_id = params[:dialogID]

		if @chat.save
			result = {"new" => false, "chat" => @chat}
			render :json => @chat.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def getChatWithDialog
		@chat = Chat.where("dialog_id = ?", params[:dialogID])

		if @chat
          render :json => @chat.to_json, :status => 200
        else
          error_str = ""

          chat.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }

          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
        end
	end

	private
		def endedChatParams
			params.require(:chat).permit(:expert_id, :user_id, :rating)
		end

		def ratingParams
			params.require(:rating).permit(:endedChat_id, :rating)
		end
end
