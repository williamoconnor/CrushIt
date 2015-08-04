class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def signup
  	if request.post?
      # puts user_params
  		@user = User.new(user_params)
      @user.correspondences = 0
      @user.shared_to_fb = false
      @user.expert_id = 0

  		if @user.save
          render :json => @user.to_json, :status => 200
      else
          error_str = ""

          @user.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }
          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
      end
  	end
  end

  def signin
  	email = params[:email]
    password = params[:password]

    @user = User.find_by email: email
    if @user && @user.password == password
      result = {"result" => "success", "user" => @user}
  		render :json => result.to_json, :status => 200
  	elsif request.post?
      result = {"result" => "failure"}
  		render :json => result.to_json, :status => 400	
  	end
  end

  def getUsers
    # return the user info for each of the qb id's passed in
    @users = Array.new
    qb_ids = params[:qb_ids]
    qb_ids.each do |qb_id|
      @users.push(User.find_by qb_id: qb_id)
    end
    if @users
      render :json => @users.to_json, :status => 200
    else
      error_str = ""

      @users.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def getQBUser
    # return the user object for a given qbID
    @user = User.find_by qb_id: params[:qb_id]

    if @user
      render :json => @user.to_json, :status => 200
    else
      error_str = ""

      @user.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def changePassword
    user = User.find_by email: params[:email]

    if user
      user.password = params[:password]
      if user.save
        result = {"result" => "success"}
        render :json => result, :status => 200
      else
        error_str = ""

        user.errors.each{|attr, msg|           
          error_str += "#{attr} - #{msg},"
        }
                  
        @e = Error.new(:status => 400, :message => error_str)
        render :json => @e.to_json, :status => 400
      end
    else
      result = {"result" => "failure", "reason" => "No user found with that email"}
      render :json => result, :status => 405
    end

  end

  def getUser
    #return the user object for a given email
    @user = User.find_by email: params[:email]

    if user
      render :json => @user.to_json, :status => 200
    else
      error_str = ""

      @user.errors.each{|attr, msg|    
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def purchaseCorrespondence
    @user = User.find_by email: params[:email]
    @user.correspondences += params[:correspondences]

    if @user.save
          render :json => @user.to_json, :status => 200
      else
          error_str = ""

          @user.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }
          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
      end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :age, :gender, :interest, :qb_id, :expert_id, :qb_code)
    end

end

