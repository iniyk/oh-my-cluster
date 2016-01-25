class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)
    password = params[:password]
    id_rsa = params[:id_rsa]
    @node.id_rsa = id_rsa

    respond_to do |format|
      if password == ''
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      elsif @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    node_params_submit = node_params.clone
    password = params[:password]
    id_rsa = params[:id_rsa]
    node_params_submit[:id_rsa] = id_rsa

    respond_to do |format|
      if xor password != '', id_rsa != ''
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      elsif @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:name, :address, :user, :id_rsa_pub, :info)
    end

    def xor(bool_a, bool_b)
      if bool_a && bool_b
        return false
      end
      if (!bool_a) && (!bool_b)
        return false
      end
      true
    end
end
