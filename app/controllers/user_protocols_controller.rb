class UserProtocolsController < ApplicationController

  # GET /user_protocols
  # GET /user_protocols.json
  def index
    @user_protocols = UserProtocol.all
  end

  # DELETE /user_protocols
  def destroy_all
    UserProtocol.delete_all
    respond_to do |format|
      format.html { redirect_to protocols_path, notice: 'User protocol was successfully destroyed.' }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_protocol_params
    params.require(:user_protocol).permit(:user_id, :ip_adress, :action, :controller, :description)
  end
end
