# Board of Assessors:
# Savannah = propertysales.chathamcounty.org
# Charleston = http://www.charlestoncounty.org/foreclosure/runninglist.html
# http://www.jessaminemc.com/ Jessamine County

class WebsitesController < ApplicationController
require 'open-uri'
require 'nokogiri'

  def add_fayette_upcoming_sales
    # First search through the file until you find the first p.style39 that matches a date.
    # Once you find a date continue to parse until you find a .style1>font>font which is the street.
    # Continue to search for streets unless another date is encountered.
    doc = Nokogiri::HTML(open('http://www.faycom.info/showcase.php?action=list&range=future')).css('body').first
    @test = Array.new
    @date = String.new
    doc.search('//p[@class="style39"]|//div[@class="style1"]/font/font').each do |text|
      appraisal = text.parent.children[7].to_s.split('Appraisal Amount: ')[1]
      appraisal = appraisal.split(' ')[0] if appraisal
      (@appraisal = appraisal.gsub(/\$|,/,'').to_f) if appraisal

      text.parent.search('p').first.content.to_s
      @header = text.parent.search('p').first.content.to_s
      @header = @header.split(' vs. ')
      @plaintiff = @header[0]
      @header = @header[1]
      @header = @header.split('(Action No') if @header
      @defendant = @header[0] if @header
      @header = @header[1] if @header
      @header = @header.split('to raise the principal amount of ') if @header
      @principal = @header[1].gsub(', together with interest, charges and costs).','').gsub(/\$|,/,'').to_f if @header
      @principal =~ /CANCELED/ ? @canceled = true : @canceled = false
      if text.name == 'p' && (text.content =~ Regexp.new(Date::MONTHNAMES.join('|').from(1), true))
        @date = text.content
      elsif text.name =='font'
        if !(text.content =~ /^Sale/)
          line = {'date' => @date, 'street' => text.content, 'a' => @appraisal, 'plaintiff' => @plaintiff, 
              'defendant' => @defendant, 'amount_due' => @principal, 'canceled' => @canceled}
          @test << line
          @street = text.content
        end
      end
    end
    @test.each do |entry|
      if !entry['street'].nil? && !Address.find_by_street_line_1(entry['street'])
        add_to_address_book(entry['street'], :plaintiff => entry['plaintiff'], :defendant => entry['defendant'], 
          :amount_due => entry['amount_due'], :cancelled => entry['canceled'],
          :sale_date => entry['date'], :appraised_value => entry['a'])
      end
    end
  end

  def add_fayette_past_sales
    doc = Nokogiri::HTML(open('http://www.faycom.info/showcase.php?action=list&range=past'))
    @test = Array.new
    count = 0
    doc.search('tr > .style40 +.style40 +.style40 > .style47').each do |text|
      @test << text.content if count == 0
      if count == 3
        unless text.content =~ /plaintiff/i
          @test.pop
        end
      end
      count +=1
      count = count%6
    end
    @test.each do |street|
      add_to_address_book(street, :county => 'PastSales')
    end
  end

  def add_jefferson_upcoming_sales
    @test = Array.new
    @use_line = false
    f = File.open(RAILS_ROOT+'/lib/files/jefferson.html')
    f.each_line do |line|
      @test << line if @use_line
      (line =~ /Date of Auction/ ? @use_line = true : @use_line = false )
    end
    @results = Array.new
    @test.each do |line|
      new_line = line.from(62).split('<br>')
      @sale_date = new_line[0]
      @street = new_line[1].gsub(' **WITHDRAWN**','')
      @city = new_line[2].split[0]
      @zip = new_line[2].split[1]
      @amount_due = new_line[4].gsub(/\r|\n|<\/h3>|<\/td>/,'')
      (new_line[1] =~ /withdrawn/i) ? @canceled = true : @canceled = false
      @results << [@sale_date, @street, @city, @zip, @amount_due, @canceled]
    end
    @results.each do |line|
      add_to_address_book(line[1], :city => line[2], :county => 'Jefferson', :cancelled => line[5], :amount_due => line[4], :zip => line[3],
          :sale_date => line[0])
    end
  end

  def add_to_address_book(street, options={})
    address = Address.new({
      :street_line_1 => street.gsub("'",""),
      :city => 'Lexington',
      :state => 'Ky',
      :county => 'Fayette'}.merge(options))
    address.save
  end
  # GET /websites
  # GET /websites.xml
  def index
    @websites = Website.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @websites }
    end
  end

  # GET /websites/1
  # GET /websites/1.xml
  def show
    @website = Website.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/new
  # GET /websites/new.xml
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
  end

  # POST /websites
  # POST /websites.xml
  def create
    @website = Website.new(params[:website])

    respond_to do |format|
      if @website.save
        flash[:notice] = 'Website was successfully created.'
        format.html { redirect_to(@website) }
        format.xml  { render :xml => @website, :status => :created, :location => @website }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.xml
  def update
    @website = Website.find(params[:id])

    respond_to do |format|
      if @website.update_attributes(params[:website])
        flash[:notice] = 'Website was successfully updated.'
        format.html { redirect_to(@website) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.xml
  def destroy
    @website = Website.find(params[:id])
    @website.destroy

    respond_to do |format|
      format.html { redirect_to(websites_url) }
      format.xml  { head :ok }
    end
  end
end
