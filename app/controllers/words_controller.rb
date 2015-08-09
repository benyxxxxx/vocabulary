class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  ##after_action :u, only: [:edit, :update, :stream, :new, :create]

  protect_from_forgery except: :stream

  skip_before_filter :verify_authenticity_token
  
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
 
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end
 
  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
 
      render :text => '', :content_type => 'text/plain'
    end
  end


  # GET /words
  # GET /words.json
  def index
    @words = Word.all
  end

  ##test
  def react
  end

  ##test
  def tmp
#    @words = Word.find(params[:id]);
  end
  
  ##test
  def tmpincr
    @word = Word.find_by_word(params[:name])
    @word.incrementDue(rand(10)*60*24);
    @word.save
  end
  
  # GET /words/play

  def play  
    @words = Word.all;
  end
  
  
  def incrementdue 
    @word = Word.find(params[:id]);
    @word.incrementDue(params[:level]);
    @word.save
    redirect_to action: params[:task], continue: '1'  
  end

  
  def indexSome
    @kanji = Kanji.find(params[:id]);
    @words = @kanji.getWords
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @task = "show"
  end

  # GET /words/new
  def new
    @word = Word.new
    @words = Word.all
  end

  # GET /words/1/edit
  def edit
    
  end

  def study
    if params[:currentIdx] 
      Word.allocateNew
    end
    @news = Word.getNew
    @inLearn = Word.getInLearn
    @dues = Word.getDue
    @word = Word.getCurrentWord
    @task = "study"
  end 

  ## API method 
  def stream
    response.headers['Content-Type'] = 'text/plain'    
    unless Word.find_by_word(params[:word]) 
      @word = Word.new()
      @word.word = params[:word];
      @word.createLinks
      @word.save
      
      response.stream.write "You added----->"+ params[:word] + ". Thank you!!"
    else
      response.stream.write "Word exists. Thank you!!"
      
    end
    
  ensure
    response.stream.close
  end
  

  def update_kanji()
    Word.find_each() do |word|
      word.createLinks
    end
  end

  
  # POST /words
  # POST /words.json
  def create
    
    @word = Word.new(word_params)
    @words = Word.all
    @word.createLinks
      
    begin
      @word.save
      puts @word.errors.full_messages
      redirect_to action: "new", notice: 'Pedido enviado com sucesso.'  
      #  format.json { render :show, status: :created, location: @word }
    rescue ActiveRecord::RecordNotUnique => e
      @word.errors.add(@word.word, "Exists already") 
      #@word.errors = 'Exist.' 
      render :edit 
      #redirect_to action: "new", @word, notice: 'Exist.' 
    end
  end
  

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    @word.kanjis.clear
    respond_to do |format|
      if @word.update(word_params) && @word.createLinks
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:word, :due)
    end
end
