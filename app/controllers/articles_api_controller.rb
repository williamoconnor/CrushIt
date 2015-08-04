class ArticlesApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
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

    if @article
      render :file => @article.file_path
    else
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

  	@article = Article.new do |a|
  		a.name = params[:article][:name]
      a.author = params[:article][:author]
      a.file_path = "articles/#{params[:post][:file_name]}"
  	end

  	if @article.save
      render :text => "Alomst done! Send the file to Will, and he will upload it to the server (that feature will be added to this page shortly)"
    else
      error_str = ""

      article.errors.each{|attr, msg|           
        error_str += "#{attr} - #{msg},"
      }
                
      @e = Error.new(:status => 400, :message => error_str)
      render :json => @e.to_json, :status => 400
    end
  end

  def new
    @article = Article.new
  end

  private
    def article_params
      params.require(:article).permit(:name, :body)
    end
end
