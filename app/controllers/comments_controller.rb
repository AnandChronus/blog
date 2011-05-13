class CommentsController < ApplicationController
  before_filter :not_viewable, :except => [:create, :destroy, :create_reply, :show_reply]

  # GET /comments
  # GET /comments.xml

  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  def create_reply
    @comment = Comment.new(:content => params[:content])
    @parent_id = params[:cid]
    @parent_comment = Comment.find_by_id(@parent_id)
    if current_user != nil
      @comment.user_id = current_user.id;
    else
      redirect_to new_user_session_path
      return
    end
    @comment.blog_id = session[:blog_id]

    respond_to do |format|
      if @comment.save
        @invalid = false
        @comment.move_to_child_of @parent_comment

        @blog = Blog.find(@comment.blog_id)
        @blog_comments = []
        @blog.comments.all(:order => "created_at DESC").each do |c|
          @blog_comments << c if c.root?
        end
        @top = @blog_comments.count
        @top = (@top.even?) ? 1 : 0

        format.js
      else
        @invalid = true
        format.js
      end
    end
  end
  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(:content => params[:content])
    #@comment.content = params[:content]
    if current_user != nil
      @comment.user_id = current_user.id;
    else
      redirect_to new_user_session_path
      return 
    end
    @comment.blog_id = session[:blog_id]
    @blog_root_comments = []
    Blog.find_by_id(@comment.blog_id).comments.all(:order => "created_at DESC").each do |c|
      @blog_root_comments << c if c.root?
    end
    @top = @blog_root_comments.count
    @top = (@top.even?) ? 0 : 1

    respond_to do |format|
      if @comment.save
        @invalid = false
        format.js
        format.html { redirect_to(Blog.find_by_id(@comment.blog_id)) }
        format.xml  { render :xml => @comment.blog_id, :status => :created, :location => @comment }
      else
        @invalid = true
        format.js
        format.html { redirect_to(Blog.find_by_id(@comment.blog_id), :notice => 'Comment cannot be blank') }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    bid = @comment.blog_id

    @comment.deleted_parent = true
    @comment.save
    @comment = Comment.find(params[:id])
    @comment.content = '<-deleted->'
    @comment.save
    c1 = @comment
    while !c1.nil? and c1.leaf? do
      cp = c1.parent if !c1.parent.nil?
      cp = cp.nil? ? nil : cp.deleted_parent ? cp : nil
      c1.destroy
      c1 = (cp.nil?)? nil : Comment.find_by_id(cp.id)
    end
    #end while @com_par.deleted_parent == false and @com_par.leaf?

    respond_to do |format|
      format.html { redirect_to(Blog.find_by_id(bid)) }
      format.xml  { head :ok }
    end
  end
end
