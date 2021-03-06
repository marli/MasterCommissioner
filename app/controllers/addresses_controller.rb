class AddressesController < ApplicationController
  # GET /addresses
  # GET /addresses.xml
  def index
    @county = params[:county] if ['Fayette', 'Jefferson'].include? params[:county]
    @city_center = "38.041968, -84.503795"
    @city_center = @lexington   = "38.041968, -84.503795"  if (@county == 'Fayette')
    @city_center = @louisville  = "38.235483, -85.729065" if (@county == 'Jefferson')
    counter = 300

    page = (params[:page] || 0).to_i*counter
    @order = 'id'
    if params[:sort_by] && Address.column_names.include?(params[:sort_by])
      @order = params[:sort_by]
    end
    @addresses = Address.all(:conditions => ["county = ? and cancelled = false", params[:county]], :order => @order, :offset => page, :limit => counter)
    @page = page/counter
    @page_limit = (Address.all(:conditions => ["county = ? and cancelled = ?", params[:county], false]).size/counter)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addresses }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    @address = Address.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/new
  # GET /addresses/new.xml
  def new
    @address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/1/edit
  def edit
    @address = Address.find(params[:id])
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to(@address) }
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(@address) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to(addresses_url) }
      format.xml  { head :ok }
    end
  end
end
