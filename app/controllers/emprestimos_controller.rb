# encoding : utf-8
class EmprestimosController < BeautifulController

  before_filter :load_emprestimo, :only => [:show, :edit, :update, :destroy]

  # Uncomment for check abilities with CanCan
  #authorize_resource

  def index
    session[:fields] ||= {}
    session[:fields][:emprestimo] ||= (Emprestimo.columns.map(&:name) - ["id"])[0..4]
    do_select_fields(:emprestimo)
    do_sort_and_paginate(:emprestimo)
    
    @q = Emprestimo.search(
      params[:q]
    )

    @emprestimo_scope = @q.result(
      :distinct => true
    ).sorting(
      params[:sorting]
    )
    
    @emprestimo_scope_for_scope = @emprestimo_scope.dup
    
    unless params[:scope].blank?
      @emprestimo_scope = @emprestimo_scope.send(params[:scope])
    end
    
    @emprestimos = @emprestimo_scope.paginate(
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
        render :json => @emprestimo_scope.all 
      }
      format.csv{
        require 'csv'
        csvstr = CSV.generate do |csv|
          csv << Emprestimo.attribute_names
          @emprestimo_scope.all.each{ |o|
            csv << Emprestimo.attribute_names.map{ |a| o[a] }
          }
        end 
        render :text => csvstr
      }
      format.xml{ 
        render :xml => @emprestimo_scope.all 
      }             
      format.pdf{
        pdfcontent = PdfReport.new.to_pdf(Emprestimo,@emprestimo_scope)
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
      format.json { render :json => @emprestimo }
    end
  end

  def new
    @emprestimo = Emprestimo.new

    respond_to do |format|
      format.html{
        if request.headers['X-PJAX']
          render :layout => false
        else
          render
        end
      }
      format.json { render :json => @emprestimo }
    end
  end

  def edit
    
  end

  def create
    @emprestimo = Emprestimo.create(params[:emprestimo])

    respond_to do |format|
      if @emprestimo.valid? and @emprestimo.save
        format.html {
          if params[:mass_inserting] then
            redirect_to emprestimos_path(:mass_inserting => true)
          else
            redirect_to emprestimo_path(@emprestimo), :notice => t(:create_success, :model => "emprestimo")
          end
        }
        format.json { render :json => @emprestimo, :status => :created, :location => @emprestimo }
      else
        format.html {
          if params[:mass_inserting] then
            redirect_to emprestimos_path(:mass_inserting => true), :error => t(:error, "Error")
          else
            render :action => "new"
          end
        }
        format.json { render :json => @emprestimo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @emprestimo.update_attributes(params[:emprestimo])
        format.html { redirect_to emprestimo_path(@emprestimo), :notice => t(:update_success, :model => "emprestimo") }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @emprestimo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @emprestimo.destroy

    respond_to do |format|
      format.html { redirect_to emprestimos_url }
      format.json { head :ok }
    end
  end

  def batch
    attr_or_method, value = params[:actionprocess].split(".")

    @emprestimos = []    
    
    Emprestimo.transaction do
      if params[:checkallelt] == "all" then
        # Selected with filter and search
        do_sort_and_paginate(:emprestimo)

        @emprestimos = Emprestimo.search(
          params[:q]
        ).result(
          :distinct => true
        )
      else
        # Selected elements
        @emprestimos = Emprestimo.find(params[:ids].to_a)
      end

      @emprestimos.each{ |emprestimo|
        if not Emprestimo.columns_hash[attr_or_method].nil? and
               Emprestimo.columns_hash[attr_or_method].type == :boolean then
         emprestimo.update_attribute(attr_or_method, boolean(value))
         emprestimo.save
        else
          case attr_or_method
          # Set here your own batch processing
          # emprestimo.save
          when "destroy" then
            emprestimo.destroy
          end
        end
      }
    end
    
    redirect_to :back
  end

  def treeview

  end

  def treeview_update
    modelclass = Emprestimo
    foreignkey = :emprestimo_id

    render :nothing => true, :status => (update_treeview(modelclass, foreignkey) ? 200 : 500)
  end
  
  private 
  
  def load_emprestimo
    @emprestimo = Emprestimo.find(params[:id])
  end
end