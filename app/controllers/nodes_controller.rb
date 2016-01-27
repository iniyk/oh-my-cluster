require 'net/ssh'

class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy, :status]

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
    ret_code = 0

    if password != ''
      ret_code = append_to_node(@node.user, password, @node.id_rsa_pub, @node.address)
      ret_code |= pending_node(@node.user, @node.id_rsa, @node.address)
    end

    respond_to do |format|
      if password != '' and ret_code == 0 and @node.save
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
    ret_code = 0

    if password != '' and id_rsa != ''
      ret_code = append_to_node(@node.user, password, @node.id_rsa_pub, @node.address)
      ret_code |= pending_node(@node.user, @node.id_rsa, @node.address)
    end

    respond_to do |format|
      if (not xor password == '', id_rsa == '') and ret_code == 0 and @node.update(node_params)
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

  # GET /nodes/1/status
  def status
    render 'show'
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

    def append_to_node(user, password, id_rsa_pub, address)
      ret_code = 0
      begin
        Net::SSH.start( address,
                        user,
                        :password => password
        ) do |session|
          ret_str = session.exec! "echo \"#{id_rsa_pub}\" >> ~/.ssh/authorized_keys"
          if ret_str != ''
            ret_code = 2
          end
        end
      rescue
        return 1
      end
      ret_code
    end

    def pending_node(user, id_rsa, address)
      ret_code = 0

      begin
        file_path = "/tmp/id_rsa_#{Time.now.to_i.to_s}"
        file = File.new file_path, 'w'
        file.puts id_rsa
      rescue
        ret_code = 2
      ensure
        file.close
      end

      return ret_code unless ret_code == 0

      begin
        Net::SSH.start( address,
                        user,
                        :host_key => 'ssh-rsa',
                        :keys => [file_path]
        ) do |session|
          session.exec! 'touch .ror_accessed'
        end
      rescue
        return 1
      end
      0
    end
end
