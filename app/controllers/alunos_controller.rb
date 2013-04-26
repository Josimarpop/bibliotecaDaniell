# encoding : utf-8
class AlunosController < BeautifulController

  before_filter :load_aluno, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:aluno] ||= (Aluno.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:aluno)
    do_sort_and_paginate(:aluno)
    
    @q = Aluno.search(
      params[:q]
    )

    @aluno_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @aluno_scope_for_scope = @aluno_scope.dup
    
    unless params[:scope].blank?
      @aluno_scope = @aluno_scope.send(params[:scope])
    end
    
    @alunos = @aluno_scope.paginate(
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
        render :json => @aluno_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Aluno.attribute_names
          @aluno_scope.all.each{ |o|
            csv << Aluno.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @aluno_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Aluno,@aluno_scope)
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
      format.json { render :json => @aluno }
    end
  end

  def new
    @aluno = Aluno.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @aluno }
    end
  end

  def edit
    
  end

  def create
    @aluno = Aluno.create(params[:aluno])

    respond_to do |format|
      if @aluno.save
        format.html {
          if params[:mass_inserting] then
            redirect_to alunos_path(:mass_inserting => true)
          else
            redirect_to aluno_path(@aluno), :notice => t(:create_success, :model => "aluno")
          end
        }
        format.json { render :json => @aluno, :status => :created, :location => @aluno }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to alunos_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @aluno.update_attributes(params[:aluno])
        format.html { redirect_to aluno_path(@aluno), :notice => t(:update_success, :model => "aluno") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @aluno.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @aluno.destroy

    respond_to do |format|
      format.html { redirect_to alunos_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @alunos = []    
    
    Aluno.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:aluno)

        @alunos = Aluno.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @alunos = Aluno.find(params[:ids].to_a)
      end

      @alunos.each{ |aluno|
        if not Aluno.columns_hash[attr_or_method].nil? and
               Aluno.columns_hash[attr_or_method].type == :boolean then
         aluno.update_attribute(attr_or_method, boolean(value))
         aluno.save
        else
          case attr_or_method
          # Set here your own batch processing
          # aluno.save
          when "destroy" then
            aluno.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Aluno
    foreignkey = :aluno_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_aluno
    @aluno = Aluno.find(params[:id])
  end
end

