class ExpertsController < ApplicationController
  def show
  	expert = Expert.find(params[:expertID])
    user = User.where("expertID = ?", params[:expertID]).first

    if expert && user
      result = {"expert" => expert, "user" => user}
      render :json => result.to_json, :status => 200
    else
      error_str = ""

      expert.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      e = Error.new(:status => 400, :message => error_str)
      render :json => e.to_json, :status => 400
    end
  end

  def list
  	experts = Expert.where("specialty = ? OR specialty2 = ? OR specialty3 = ? OR specialty4 = ?", params[:specialty], params[:specialty], params[:specialty], params[:specialty])
  	expertsArray = Array.new
  	experts.each do |exp|
  		user = User.where("expertID = ?", exp[:id])[0]
  		person = {"user" => user, "expert" => exp}
  		expertsArray.push(person)
  	end
  	expertsResult = {"experts" => expertsArray}

    if experts
      render :json => expertsResult.to_json, :status => 200
    else
      error_str = ""

      experts.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      e = Error.new(:status => 400, :message => error_str)
      render :json => e.to_json, :status => 400
    end
  end

  def updateAvailability
    expert = Expert.find(params[:expertID])

    expert.availability = params[:available]

    if expert.save
        render :json => expert.to_json, :status => 200
    else
        error_str = ""

        expert.errors.each{|attr, msg|           
          error_str += "#{attr} - #{msg},"
        }
        puts error_str
                  
        e = Error.new(:status => 400, :message => error_str)
        render :json => e.to_json, :status => 400
    end
  end

  def newExpert
    @expert = Expert.new()
  end

  def createExpert
    if params[:post][:passcode] == 'password'
      @expert = Expert.new()
      @expert.specialty = params[:expert][:specialty]
      @expert.specialty2 = params[:expert][:specialty2]
      @expert.specialty3 = params[:expert][:specialty3]
      @expert.specialty4 = params[:expert][:specialty4]
      @expert.fb_pic_link = params[:expert][:fb_pic_link]
      @expert.rating = 0
      @expert.cost = 1
      @expert.totalRating = 0
      @expert.correspondences = 0
      @expert.unpaid_correspondences = 0
      @expert.availability = false

      if @expert.save
          user = User.find_by email: params[:post][:email]
          if user
            user.expertID = @expert.id
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
                    
          e = Error.new(:status => 400, :message => error_str)
          render :json => e.to_json, :status => 400
      end    
    else
      render :text => "<h2>Not Authorized. Check that you have the correct password - you said #{params[:post]}</h2>".html_safe, :status => 400
    end
  end

  def payExpert
    @expert = Expert.find(params[:expertID])
    @user = User.where("expertID = ?", params[:expertID]).first

    if !@expert.blank?
      @amt = @expert.unpaid_correspondences * @expert.cost
    else
      @amt = 0
    end

  end

  def submitPayment
    @expert = Expert.find(params[:expertID])
    @user = User.where("expertID = ?", params[:expertID]).first

    submittedCode = params[:post][:kitty]
    code = "123456789"

    @expert.correspondences += @expert.unpaid_correspondences
    @expert.unpaid_correspondences = 0

    if @expert.save
      render :text => "Successfully paid expert #{@user.username}"
    else
      error_str = ""

      @expert.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
      puts error_str
                
      e = Error.new(:status => 400, :message => error_str)
      render :json => e.to_json, :status => 400
    end
  end

  private
    def expertParams
      params.require(:expert).permit(:specialty, :specialty2, :specialty3, :specialty4, :fb_pic_link)
    end


end
