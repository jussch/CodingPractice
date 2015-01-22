class NotesController < ApplicationController

  before_action :authorize_actions

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.save
    redirect_to track_url(@note.track_id)
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy
    redirect_to track_url(note.track_id)
  end

  private
  def note_params
    params.require(:note).permit(:body,:user_id,:track_id)
  end

  def authorize_actions
    return if params[:id].nil?
    note = Note.find(params[:id])
    if note.nil? || current_user.id != note.user_id
      render text: "Go away malicious user!"
      error[:base] << "Unauthorized Actions"
    end
  end

end
