class ArticlesController < ApplicationController
	
	before_action :set_article, only: [:show, :edit, :update, :destroy]
	before_action :require_user, except: [:index, :show]
	before_action :require_same_user, only: [:edit, :update, :destroy]

	def show
		
	end

	def index
		@articles = Article.paginate(page: params[:page], per_page: 2)
	end

	def new
		@article = Article.new
	end

	def create
		# we have to white list what's coming from internet
		@article = Article.new(article_params)
		@article.user = current_user
		if @article.save
			flash[:notice] = "Article was created successfully"
			redirect_to @article  # this redirect to 'show'
		else
			render 'new'
		end
	end

	def edit
		
	end

	def update
		if @article.update(article_params)
			flash[:notice] = "Article was updated successfully"
			redirect_to @article
		else
			render 'edit'
		end
	end

	def destroy
		@article.destroy
		redirect_to articles_path
	end

	private

	# This is call by before_action helper
	def set_article
		@article = Article.find(params[:id])
	end

	# This is to whitelist :title and :description
	def article_params
		params.require(:article).permit(:title, :description, category_ids: [])
	end

	# This is to check that only a user who a particular article belongs
	# to can edit update destroy that article
	def require_same_user
		# if current_user is the article or an admin then proceed
		if current_user != @article.user && !current_user.admin?
			flash[:danger] = "You can only edit or delete your own articles"
			redirect_to root_path
		end
	end
end