class ProfilesController < ApplicationController
  before_action :authenticate_member!
  before_action :set_member
  
  def edit
    authorize @profile
  end

  def upload_avatar 
    authorize @profile
    if current_member.profile
      @profile = @member.profile
    else
      @profile = @member.create_profile!
    end

    respond_to do |format|
      # check if a picture was chosen from the file system
      if profile_params["avatar"] && @profile.update(profile_params)
        format.html { redirect_to profile_path,
          notice: "Profile was updated successfully." }
      else
        format.html { redirect_to profile_path,
          alert: "Profile was not saved. Make sure that an image format is correct." }
      end
    end
  end
  
  private

    def set_member
      if current_member
        @member = Member.find(current_member.id)
      else
        @member = Member.find(params[:member_id])
      end
    end

    def profile_params
      params.require(:profile).permit(:bio, :member_id, :avatar)
    end
end