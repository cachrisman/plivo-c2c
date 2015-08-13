class CallsController < ApplicationController
  before_filter :authenticate
  skip_before_action :verify_authenticity_token, only: [:update, :hangup_callback] if :xml_request?
  before_action :set_call, only: [:show, :edit, :update, :hangup_callback, :destroy]
  before_action :set_plivo, only: [:create, :hangup]

  def index
    @calls = Call.all
  end

  def active
    @calls = Call.where.not(CallStatus: "completed")
  end

  def show
    respond_to do |format|
      format.html
      format.xml {
        r = {'Speak' => "Welcome to Charlie's demo conference.",
           'Conference' => "demo" + Time.now().strftime('%Y%m%d')}.to_xml(:root=>'Response')
        render :xml => r
      }
    end
  end

  def new
    @call = Call.new
  end

  def edit
  end

  def create
    @call = Call.new(call_params)
    respond_to do |format|
      if @call.save
        id = @call.id
        response1 = make_call(call_params['From'], id)
        response2 = make_call(call_params['To'], id)
        uuids = {'request_uuids'=> [response1[1]['request_uuid'],response2[1]['request_uuid']]}
        @call.update(uuids)
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
        format.json { render :show, status: :created, location: @call }
      else
        format.html { render :new }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @call['request_uuids'].include?(params[:RequestUUID]) and @call.update(update_call_params)
        r = {'Speak' => "Welcome to Charlie's demo conference.",
             'Conference' => "demo" + Time.now().strftime('%Y%m%d')}.to_xml(:root=>'Response')
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
        format.xml  { render :xml => r }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
        format.xml  { render xml:  @call.errors, status: :unprocessable_entity }
      end
    end
  end

  def hangup_callback
    respond_to do |format|
      if @call.update(update_call_params)
        format.json { head :no_content }
        format.xml  { head :no_content }
      else
        format.json { render json: @call.errors, status: :unprocessable_entity }
        format.xml  { render xml:  @call.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def authenticate
      if not xml_request?
        authenticate_or_request_with_http_basic do |name, password|
          name == "plivo" &&  password == "Charlie1234"
        end
      end
    end

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
        'hangup_url' => hangup_callback_url(id) + ".xml",
        'time_limit' => '30',
        'ring_timeout' => '15'
       }
       response = @plivo.make_call(call)
    end

    def call_params
      params.require(:call).permit(:name, :From, :To)
    end

    def update_call_params
      par = params.permit(:To, :CallStatus, :CallUUID)
      p "Update_call_params: " + par.to_s
      par
    end

    def xml_request?
      request.format.xml?
    end

end
