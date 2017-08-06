class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    @months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ]
    @years = [
      2010,
      2011,
      2012,
      2013,
      2014,
      2015,
      2016,
      2017,
      2018,
      2019,
      2020,
      2021,
      2022,
    ]
    @current_month = Time.now.strftime("%m")
    @current_year = Time.now.strftime("%Y")
    if params[:month]
      @current_month = @months.index(params[:month])
    end
    if params[:year]
      @current_year = params[:year]
    end
    test3 = Record

    if Rails.env == "production"
      test3 = test3.where("extract(month from date) = ?", @current_month)
      test3 = test3.where("extract(year from date) = ?", @current_year)
    else
      test3 = test3.where("cast(strftime('%m', date) as int) = ?", @current_month)
      test3 = test3.where("cast(strftime('%Y', date) as int) = ?", @current_year)
    end
    @yuki_sum_split =      test3.where(:who => "Yuki" ).where(:split => "Split").sum(:price)
    @yuki_sum_non_split =  test3.where(:who => "Yuki" ).where(:split => "Non-Split").sum(:price)
    @seb_sum_split =       test3.where(:who => "Seb" ).where(:split => "Split").sum(:price)
    @seb_sum_non_split =   test3.where(:who => "Seb" ).where(:split => "Non-Split").sum(:price)
    @seb_sum =             test3.where(:who => "Seb" ).where(:split => "Alone").sum(:price)
    @yuki_sum =            test3.where(:who => "Yuki" ).where(:split => "Alone").sum(:price)
    if params[:q]
      search_term = params[:q]
      @button = search_term
      if Rails.env == "production"
        if search_term == "ShowShared"
          test3 = test3.where.not("split ilike ?", "%Alone%")
        elsif search_term == "ShowSebAlone"
          test3 = test3.where("who ilike ?", "%Seb%").where("split ilike ?", "%Alone%")
        elsif search_term == "ShowYukiAlone"
          test3 = test3.where("who ilike ?", "%Yuki%").where("split ilike ?", "%Alone%")
        else
          if @current_month == Time.now.strftime("%m").to_i
            test3 = test3.where("description ilike ?", "%#{search_term}%")
          end
        end
      else
        if search_term == "ShowShared"
          test3 = test3.where.not("split LIKE ?", "%Alone%")
        elsif search_term == "ShowSebAlone"
          test3 = test3.where("who LIKE ?", "%Seb%").where("split LIKE ?", "%Alone%")
        elsif search_term == "ShowYukiAlone"
          test3 = test3.where("who LIKE ?", "%Yuki%").where("split LIKE ?", "%Alone%")
        else
          if @current_month == Time.now.strftime("%m").to_i
            test3 = test3.where("description LIKE ?", "%#{search_term}%")
          end
        end
      end
    end
    @records = test3.order('date DESC')
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to action: "index", notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to action: "index", notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:date, :who, :description, :split, :price, :comment)
    end
end
