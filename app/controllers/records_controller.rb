class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    current_month = Time.now.strftime("%m")
    test3 = Record
    if Rails.env == "production"
      # test3= Record.where("extract(year from release_date) = ?", 2013)
      test3 = Record.where("extract(month from date) = ?", 07)
    else
      test3 = Record.where("cast(strftime('%m', date) as int) = ?", current_month)
    end
    @yuki_sum_split =      Record.calculate(test3, 'Yuki', 'Split')
    @yuki_sum_non_split =  Record.calculate(test3, 'Yuki', 'Non-Split')
    @seb_sum_split =       Record.calculate(test3, 'Seb', 'Split')
    @seb_sum_non_split =   Record.calculate(test3, 'Seb', 'Non-Split')
    @seb_sum =             Record.calculate(test3, 'Seb', 'Alone')
    @yuki_sum =            Record.calculate(test3, 'Yuki', 'Alone')
    if params[:q]
      search_term = params[:q]
      @button = search_term
      if Rails.env == "production"
        if search_term == "ShowShared"
          @records = test3.where.not("split ilike ?", "%Alone%").order('date ASC')
        elsif search_term == "ShowSebAlone"
          @records = test3.where("who ilike ?", "%Seb%").where("split ilike ?", "%Alone%").order('date ASC')
        elsif search_term == "ShowYukiAlone"
          @records = test3.where("who ilike ?", "%Yuki%").where("split ilike ?", "%Alone%").order('date ASC')
        else
          @records = test3.where("description ilike ?", "%#{search_term}%")
        end
      else
        if search_term == "ShowShared"
          @records = test3.where.not("split LIKE ?", "%Alone%").order('date ASC')
        elsif search_term == "ShowSebAlone"
          @records = test3.where("who LIKE ?", "%Seb%").where("split LIKE ?", "%Alone%").order('date ASC')
        elsif search_term == "ShowYukiAlone"
          @records = test3.where("who LIKE ?", "%Yuki%").where("split LIKE ?", "%Alone%").order('date ASC')
        else
          @records = test3.where("description LIKE ?", "%#{search_term}%")
        end
      end
    else
      @records = test3.order('date ASC')

    end
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
