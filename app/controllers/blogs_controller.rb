class BlogsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]

  # GET /blogs
  # GET /blogs.xml
  def index
    @blogs = Blog.all(:order => "created_at DESC")
    @blogs_p = Blog.all(:order => "rating DESC")
    session[:user_id] = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    @blog = Blog.find(params[:id])
    @blog_comments = []
    @blog.comments.all(:order => "created_at DESC").each do |c|
      @blog_comments << c if c.root?
    end
    session[:blog_id] = @blog.id
    @top = @blog_comments.count
    @top = (@top.even?) ? 1 : 0

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])
    @blog.user_id = current_user.id
    @blog.rating = 0

    respond_to do |format|
      if @blog.save
        format.html { redirect_to(@blog, :notice => 'Blog was successfully created.') }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to(@blog, :notice => 'Blog was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end

  def inc_rating
    @blog = Blog.find(session[:blog_id])
    @blog.rating += 1
    @blog.save
    redirect_to @blog
  end

  def show_reply
    @idname = "r2r_#{params[:id]}"
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def hide_reply
    @idname = "r2r_#{params[:id]}"
    @id = params[:id]
    @comment = Comment.find_by_id(@id)
    @blog = Blog.find(@comment.blog_id)
    @blog_comments = []
    @blog.comments.all(:order => "created_at DESC").each do |c|
      @blog_comments << c if c.root?
    end
    @top = @blog_comments.count
    @top = (@top.even?) ? 1 : 0
    respond_to do |format|
      format.js
    end
  end

end
