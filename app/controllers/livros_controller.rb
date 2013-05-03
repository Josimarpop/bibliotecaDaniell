# encoding : utf-8
class LivrosController < BeautifulController

  before_filter :load_livro, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:livro] ||= (Livro.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:livro)
    do_sort_and_paginate(:livro)
    
    @q = Livro.search(
      params[:q]
    )

    @livro_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @livro_scope_for_scope = @livro_scope.dup
    
    unless params[:scope].blank?
      @livro_scope = @livro_scope.send(params[:scope])
    end
    
    @livros = @livro_scope.paginate(
      :page => params[:page],
      :per_page => 20
    ).all

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json{
        render :json => @livro_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Livro.attribute_names
          @livro_scope.all.each{ |o|
            csv << Livro.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @livro_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Livro,@livro_scope)
        send_data pdfcontent
      }
    end
  end

  def show
    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @livro }
    end
  end

  def new
    @livro = Livro.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @livro }
    end
  end

  def edit
    
  end

  def create
    @livro = Livro.create(params[:livro])

    respond_to do |format|
      if @livro.save
        format.html {
          if params[:mass_inserting] then
            redirect_to livros_path(:mass_inserting => true)
          else
            redirect_to livro_path(@livro), :notice => t(:create_success, :model => "livro")
          end
        }
        format.json { render :json => @livro, :status => :created, :location => @livro }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to livros_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @livro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @livro.update_attributes(params[:livro])
        format.html { redirect_to livro_path(@livro), :notice => t(:update_success, :model => "livro") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @livro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @livro.destroy

    respond_to do |format|
      format.html { redirect_to livros_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @livros = []    
    
    Livro.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:livro)

        @livros = Livro.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @livros = Livro.find(params[:ids].to_a)
      end

      @livros.each{ |livro|
        if not Livro.columns_hash[attr_or_method].nil? and
               Livro.columns_hash[attr_or_method].type == :boolean then
         livro.update_attribute(attr_or_method, boolean(value))
         livro.save
        else
          case attr_or_method
          # Set here your own batch processing
          # livro.save
          when "destroy" then
            livro.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Livro
    foreignkey = :livro_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_livro
    @livro = Livro.find(params[:id])
  end
end

