class ChatsController < ApplicationController
	def new
		chat = Chat.new()
		chat.userID = params[:correspondence][:userID]
		chat.expertID = params[:correspondence][:expertID]
		chat.renewals = 0
		chat.active = true
		chat.rating = 0
		chat.dialog_id = ""

		existingChat = Chat.where("active = ? AND userID = ? AND expertID = ?", true, chat.userID, chat.expertID)
		if !existingChat.blank?
			result = {"new" => false, "chat" => chat}
			render :json => result.to_json, :status => 200
		else
			if chat.save
				result = {"new" => true, "chat" => chat}
				render :json => result.to_json, :status => 200
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

	def endChat
		chat = Chat.find(params[:chatID])
		chat.active = false
		chat.pendingRenewal = false

		expert = Expert.where("id = ?", chat.expertID)
		expert.correspondences += chat.renewals + 1

		if chat.save && expert.save
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

	def submitRating
	  	if request.post?
	  		chat = Chat.find(ratingParams[:chatID])
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

	def userActiveChats
		chats = Chat.where("userID = ? AND active = ?", params[:userID], true)
		experts = Array.new
		chats.each do |chat|
			expertID = chat.expertID
			expertInfo = Expert.find(expertID)
			userInfo = User.where("expertID = ?", expertID).first
			expert = {"user" => userInfo, "expert" => expertInfo}
			experts.push(expert)
		end
		if chats && experts
			result = {"chats" => chats, "experts" => experts}
			render :json => result.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def expertActiveChats
		chats = Chat.where("expertID = ? AND active = ?", params[:expertID], true)
		users = Array.new
		chats.each do |chat|
			userID = chat.userID
			userInfo = User.find(userID)
			users.push(userInfo)
		end
		if chats && users
			result = {"chats" => chats, "users" => users}
			render :json => result.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def unratedInactiveChats
		unratedChats = Chat.where("rating = ? AND active = ? AND userID = ?", 0, false, params[:userID])

		if unratedChats.blank?
			result = {"empty" => true}
		else
			result = {"empty" => false, "chats" => unratedChats}
		end
		render :json => result.to_json, :status => 200
	end

	def renewChatRequest
		chat = Chat.find(params[:chatID])
		chat.pendingRenewal = params[:setting]

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

	def renewChat
		chat = Chat.find(params[:chatID])
		chat.pendingRenewal = false
		chat.renewals += 1 # manage payment and shit on the front end

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

	def addDialogId
		chat = Chat.find(params[:chatID])
		chat.dialog_id = params[:dialogID]

		if chat.save
			result = {"new" => false, "chat" => chat}
			render :json => chat.to_json, :status => 200
		else
	      	result = {"result" => "failure"}
	  		render :json => result.to_json, :status => 400
		end
	end

	def getChatWithDialog
		chat = Chat.where("dialog_id = ?", params[:dialogID])

		if chat
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

	private
		def endedChatParams
			params.require(:chat).permit(:expertID, :userID, :rating)
		end

		def ratingParams
			params.require(:rating).permit(:endedChatID, :rating)
		end
end
