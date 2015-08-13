class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :answer_callback, :hangup_callback, :destroy]
  before_action :set_plivo, only: [:create, :hangup]

  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
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
        id = @call.id
        response1 = make_call(call_params['from'], id)
        response2 = make_call(call_params['to'], id)
        # p "Response1: " + response1.to_s
        # p "Response2: " + response2.to_s
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
      if @call.update(update_call_params)
        r = {'Speak' => "Welcome to Charlie's demo conference.",
             'Conference' => "demo" + Time.now().strftime('%Y%m%d')}.to_xml(:root=>'Response')
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
        format.xml  { render :xml => r }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  def hangup_callback
    respond_to do |format|
      if @call.update(update_call_params)
        format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
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

    def make_call(number, id)
      call = {
        'from' => ENV['CALLERID'],
        'to' => number,
        'answer_url' => call_url(id) + ".xml",
        'answer_method' => 'PUT',
        'hangup_url' => hangup_callback_url(id),
        'time_limit' => '30',
        'ring_timeout' => '15'
       }
       p "Call Params: " + call.to_s
       response = @plivo.make_call(call)
       p "Response: " + response.to_s
       return response
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:name, :from, :to)
    end

    def update_call_params
      params.require().permit(:CallUUID, :From, :To, :CallStatus, :Direction, :ALegUUID, :ALegRequestUUID)
    end
end
