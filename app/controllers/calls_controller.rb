class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :set_plivo, only: [:create, :hangup]

  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
    r = {'Speak' => "Welcome to Charlie's demo conference.",
         'Conference' => "demo" + Time.now().strftime('%Y%m%d-%H%M%S')}.to_xml(:root=>'Response')
    respond_to do |format|
      format.html
      format.xml { render :xml => r }
    end

  end

  # GET /calls/1
  # GET /calls/1.json
  def show
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end

  # POST /calls
  # POST /calls.json
  def create
    @call = Call.new(call_params)
    respond_to do |format|
      if @call.save
        call1 = {'from' => ENV['CALLERID'],
                 'to' => call_params['from'],
                 'answer_url' => ENV['ANSWER_URL'],
                 'answer_method' => ENV['ANSWER_METHOD']}
        call2 = {'from' => ENV['CALLERID'],
                 'to' => call_params['to'],
                 'answer_url' => ENV['ANSWER_URL'],
                 'answer_method' => ENV['ANSWER_METHOD']}
        p "CALL1 PARAMS: " + call1.to_s
        p "CALL2 PARAMS: " + call2.to_s

        response1 = @plivo.make_call(call1)
        response2 = @plivo.make_call(call2)
        p "Response1: " + response1.to_s
        p "Response2: " + response2.to_s
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render :show, status: :created, location: @call }
      else
        format.html { render :new }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    respond_to do |format|
      if @call.update(call_params)
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /calls/1
  # POST /calls/1.json
  def hangup
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    def set_plivo
      @plivo = Plivo::RestAPI.new(ENV['PLIVO_AUTH_ID'], ENV['PLIVO_AUTH_TOKEN'])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:name, :from, :to)
    end
end
