class ArticlesApiController < ApplicationController
  
  def get_all_articles
    @articles = Article.all

    if @articles
      render :json => @articles.to_json, :status => 200
    else
      result = {"result" => "failure"}
      render :json => result.to_json, :status => 400
    end
  end

  def get_article
  	@article = Article.find(params[:article_id])

    if !@article
      error_str = ""

      article.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end

  end
  
  def plural
  	puts "words"
  end
  
  def create

    if params[:post][:passcode] == "password"
      @article = Article.new(article_params)

      # read the text, save as body attribute
      if params[:article][:text_file] #need a better check
        # file = File.open(params[:article][:text_file], "rb")
        @article.body = params[:article][:text_file].read
      end

      if @article.save
        render :text => "Successfully uploaded article"
      else
        error_str = ""

        @article.errors.each{|attr, msg|           
          error_str += "#{attr} - #{msg},"
        }
                  
        @e = ActiveModel::Errors.new(:status => 400, :message => error_str)
        render :json => {"result" => "Failed to create article", "article" => @article.body}
      end
    else
      render :text => "<h2>Not Authorized. Check that you have the correct password</h2>".html_safe, :status => 400
    end
  end

  def new
    @article = Article.new
  end

  private
    def article_params
      params.require(:article).permit(:name, :author, :text_file)
    end
end
