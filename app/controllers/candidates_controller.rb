class CandidatesController < ApplicationController
  
  before_action :find_candidate, only: [:show, :edit, :update, :destroy, :vote]
  #或用排除寫法
  #before_action :find_candidate, except: [:index, :new,  :create]
  
  def index
    @candidates = Candidate.all
    # 沒有指定所使用 view 就使用預設的 index.html.erb
  end 
 
  def show
  end
  
# def vote
#   @candidate.vote
#   redirect_to candidates_path, notice: "Voted!"
# end
  
  def vote    
    log = Log.new(candidate: @candidate, ip_address: request.remote_ip)
    @candidate.logs << log
    @candidate.save
    redirect_to candidates_path, notice: "Voted!"
  end
  
  def new
     @candidate = Candidate.new
  end
  
  def create
     @candidate = Candidate.new(candidate_params)
     if @candidate.save
        redirect_to candidates_path, notice: "Added!"
     else
       render 'new'
       # 借用 new.html.erb 只有 name 清空，其他資料都在
       # redirect_to new_candidate_path 所有欄位都清空
     end
  end
 
  def edit
  end
  
  def update
     if @candidate.update(candidate_params)
        redirect_to candidates_path, notice: "Updated!"
     else
       render 'edit'
     end
  end
  
  def destroy
    @candidate.destroy
    # flash[:notice] = "deleted!"
    redirect_to candidates_path, notice: "deleted!"
  end

private
  def candidate_params
    params.require("candidate").permit(:name, :party, :age, :politics)
  end
  
  def find_candidate
    @candidate = Candidate.find_by(id: params[:id])
    redirect_to candidates_path, notice: "no data!" if @candidate.nil?
    # 如果要編輯的資料不存在會顯示不存在
  end
end