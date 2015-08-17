class ExpertsController < ApplicationController
  def show
  	@expert = Expert.find(params[:expert_id])
    @user = User.where("expert_id = ?", params[:expert_id]).first

    if @expert && @user
      result = {"expert" => @expert, "user" => @user}
      render :json => result.to_json, :status => 200
    else
      error_str = ""

      @expert.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def getProfPic
    @expert = Expert.find(params[:expert_id])
    @medium = expert.avatar.url(:medium, false)
    thumb = expert.avatar.url(:thumb, false)

    if @expert && @medium && thumb
      send_file medium, type: 'image/png', disposition: 'inline'
      # render :file => expert.avatar.url(:medium)
    else
      error_str = ""

      @expert.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }

      @medium.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }

      @thumb.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def listFeatured
  	@experts = Expert.where("specialty = ? OR specialty2 = ? OR specialty3 = ? OR specialty4 = ?", params[:specialty], params[:specialty], params[:specialty], params[:specialty])
  	@expertsArray = Array.new
  	@experts.each do |exp|
  		user = User.where("expert_id = ?", exp[:id])[0]
  		person = {"user" => user, "expert" => exp}
  		expertsArray.push(person)
  	end
  	expertsResult = {"experts" => expertsArray}

    if experts
      render :json => expertsResult.to_json, :status => 200
    else
      error_str = ""

      @experts.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def allFeatured
    onlineExpertsE = Expert.where("availability = ?", true)
    offlineExpertsE = Expert.where("availability = ?", false)

    @onlineExperts = Array.new
    @offlineExperts = Array.new

    onlineExpertsE.each do |expert|
      user = User.where("expert_id = ?", expert.id.to_s).first
      if user
        expertMap = {"expert" => expert, "user" => user}
        @onlineExperts.push(expertMap)
      end
    end
    offlineExpertsE.each do |expert|
      user = User.where("expert_id = ?", expert.id.to_s).first
      if user
        expertMap = {"expert" => expert, "user" => user}
        @offlineExperts.push(expertMap)
      end
    end

    if onlineExperts || offlineExperts
      result = {"online" => @onlineExperts, "offline" => @offlineExperts}
      render :json => result.to_json, :status => 200
    else
      error_str = ""

      @onlineExperts.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
      @offlineExperts.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def limitedQualified
    # manage limit in fair way - passes in array with experts of online experts
    limit = 10
    onlineExperts = params[:experts][:expert]
    totalOnlineQExperts = Expert.where("availability = ? AND featured = ?", true, false)
    # check that those are all still online
    onlineExperts.each do |e|
      if e.availability == false
        onlineExperts = onlineExperts - [e]
      end
    end
    # add experts
    counter = 0
    while onlineExperts.length <= limit 
      onlineExperts.push(totalOnlineQExperts[counter])
      counter += 1
    end

    @experts = Array.new

    onlineExperts.each do |expert|
      user = User.where("expert_id = ?", expert.id.to_s).first
      if user
        expertMap = {"expert" => expert, "user" => user}
        @experts.push(expertMap)
      end
    end

    
    render :json => experts.to_json, :status => 200
  end

  def onlineQualifiedExperts
    @experts = Expert.where("availability = ? AND featured = ?", true, false)

    if @experts
      render :json => {"result" => "success", "experts" => @experts}, :status => 200
    else
      render :json => {"result" => "failure"}, :status => 500
    end
  end

  def randomQualifiedExpert
    experts = Expert.where("availability = ? AND featured = ?", true, false)

    length = experts.length
    if length > 0
      @expert = experts[rand(0..length)]
      render :json => {"result" => "success", "expert" => @expert}, :status => 200
    else
      render :json => {"result" => "failure", "reason" => "no experts online"}, :status => 200
    end
    

  end

  def updateAvailability
    @expert = Expert.find(params[:expert_id])

    @expert.availability = params[:available]

    if expert.save
        render :json => @expert.to_json, :status => 200
    else
        error_str = ""

        @expert.errors.each{|attr, msg|           
          error_str += "#{attr} - #{msg},"
        }
        puts error_str
                  
        @e = Error.new(:status => 400, :message => error_str)
        render :json => @e.to_json, :status => 400
    end
  end

  def updateExpert
    @expert = Expert.find(params[:id])
    @expert.max_load = params[:max_load].to_i

    if @expert.save
      render :json => {"result" => "success", "expert" => @expert.to_json}, :status => 200
    else
      render :json => {"result" => "failure"}
  end

  def newExpert
    @expert = Expert.new()
  end

  def createExpert
    if params[:post][:passcode] == 'password'
      @expert = Expert.new(expertParams)
      @expert.rating = 0
      @expert.cost = 1
      @expert.total_rating = 0
      @expert.correspondences = 0
      @expert.unpaid_correspondences = 0
      @expert.availability = false

      if @expert.save
          user = User.find_by email: params[:expert][:email]
          if user
            user.expert_id = @expert.id
            user.save
            render :text => "Successfully added expert to user #{user.username}"
          else
            render :text => "<h2>User not found. Make sure you have a user account before creating expert account</h2>".html_safe
          end
      else
          error_str = ""

          @expert.errors.each{|attr, msg|           
            error_str += "#{attr} - #{msg},"
          }
          puts error_str
                    
          @e = Error.new(:status => 400, :message => error_str)
          render :json => @e.to_json, :status => 400
      end    
    else
      render :text => "<h2>Not Authorized. Check that you have the correct password</h2>".html_safe, :status => 400
    end
  end

  def payExpert
    @expert = Expert.find(params[:expert_id])
    @user = User.where("expert_id = ?", params[:expert_id]).first

    if !@expert.blank?
      @amt = @expert.unpaid_correspondences * @expert.cost
    else
      @amt = 0
    end

  end

  def submitPayment
    @expert = Expert.find(params[:expert_id])
    @user = User.where("expert_id = ?", params[:expert_id]).first

    submittedCode = params[:post][:kitty]
    code = "123456789"

    correctCode = false

    if submittedCode == code
      @expert.correspondences += @expert.unpaid_correspondences
      @expert.unpaid_correspondences = 0
      correctCode = true
    end

    if @expert.save && correctCode
      render :text => "Successfully paid expert #{@user.username}"
    else
      error_str = ""

      @expert.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
      puts error_str
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  private
    def expertParams
      params.require(:expert).permit(:specialty, :specialty2, :specialty3, :specialty4, :bio, :avatar, :email, :featured)
    end


end
