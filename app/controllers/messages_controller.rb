class MessagesController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def create
    @msg = Message.new(content: params[:content], room_id: params[:chat_id], user_id: current_user.id, )
    if @msg.save
      redirect_to("/chats/#{params[:chat_id]}")
    else
      redirect_to("/chats/#{params[:chat_id]}")
    end
  end
end
