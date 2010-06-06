class Website < ActiveRecord::Base

  require 'open-uri'

  def self.fayette_sales
    doc = open('http://www.faycom.info/showcase.php?action=list&range=future')
    lines = doc.readlines
    lines.each do |line|
      l = line.gsub(/\t/,'')
      if l =~ /^ <strong><p align="center" class="style39"> /
        # This is the Date line
        @date = l.split('class="style39"> ')[1].split(' <')[0]
        self.split_the_line(l)
      elsif l =~ /^<font face="Verdana, Arial, Helvetica, sans-serif"><font size="\+1">/
        self.split_the_line(l)
      elsif l =~ /^<font size="\+1">/
        @street = l.split('<font size="+1">')[1].split('<')[0]
      elsif l =~ /Appraisal Amount/
        @appraisal = l.split('Appraisal Amount: ')[1].split('<')[0].gsub(/\$|,/,'').to_f
      end
      if @appraisal && @street && @amount_owed
        self.add_fayette_address
      end
    end
  end

  protected 

  def self.split_the_line(line)
    @sale = line.split('font size="+1">')[1].split('<')[0]
    @plaintiff = line.split('<p align="left">')[1].split(' vs. ')[0]
    @defendant = line.split('<p align="left">')[1].split(' vs. ')[1].split(' (Action')[0]
    @case_no = line.split(' (Action No. <b>')[1].split('</b')[0]
    @amount_owed = line.split('principal amount of ')[1].split(', ')[0]
    if @amount_owed == "CANCELED"
      @canceled = true
    else
      @canceled = false
    end
  end

  def self.add_fayette_address
    Address.create(:street_line_1 => @street,
                   :city => 'Lexington',
                   :state => 'KY',
                   :county => 'Fayette',
                   :appraised_value => @appraisal,
                   :amount_due => @amount_owed,
                   :sale_date => @date,
                   :cancelled => @canceled,
                   :plaintiff => @plaintiff,
                   :defendant => @defendant,
                   :case_number => @case_no)
    @amount_owed = nil
    @appraisal = nil
    @canceled = nil
    @case_no = nil
    @defendant = nil
    @plaintiff = nil
    @sale = nil
    @street = nil
  end

end
