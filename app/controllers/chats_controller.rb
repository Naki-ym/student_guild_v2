class ChatsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!
  
  def index
    @room_users = RoomUser.where(user_id: current_user.id)
    @rooms      = []
    @room_users.each do |room_user|
      @room = Room.kept.find_by(id: room_user.room_id)
      @rooms << @room
    end
  end

  def show
    @current_room = Room.kept.find_by(id: params[:id])
    @room_users   = RoomUser.where(user_id: current_user.id)
    @rooms        = []
    @room_users.each do |room_user|
      @room = Room.kept.find_by(id: room_user.room_id)
      @rooms << @room
    end
    @messages = Message.kept.where(room_id: params[:id])
  end

  def new
    @room        = Room.new
    @myroomusers = RoomUser.where(user_id: current_user.id)
    @rooms       = []
    @roomusers   = []
    @users       = []
    @myroomusers.each do |myroomuser|
      myroom = Room.kept.find_by(id: myroomuser.room_id, is_group_chat: false)
      if myroom
        @rooms << myroom
      end
    end
    @rooms.each do |room|
      roomuser = RoomUser.where.not(user_id: current_user.id).find_by(room_id: room.id)
      if roomuser
        @roomusers << roomuser
      end
    end
    @roomusers.each do |roomuser|
      user = User.find_by(id: roomuser.user_id)
      if user
        @users << user
      end
    end
  end

  def create
    @users_id = params[:users]
    @room     = Room.new(name: params[:name], caption: params[:caption], is_group_chat: true)
    if @room.save
      @members = [current_user]
      @users_id.each do |user_id|
        new_member = User.find_by(id: user_id)
        @members << new_member
      end
      @members.each do |member|
        @room_user = RoomUser.new(room_id: @room.id, user_id: member.id)
        unless @room_user.save
          render("chats/create")
        end
      end
      redirect_to("/chats/#{@room.id}")
    else
      @error_message = "失敗しました"
      @myroomusers = RoomUser.where(user_id: current_user.id)
      @rooms = []
      @roomusers = []
      @users = []
      @myroomusers.each do |myroomuser|
        myroom = Room.kept.find_by(id: myroomuser.room_id, is_group_chat: false)
        if myroom
          @rooms << myroom
        end
      end
      @rooms.each do |room|
        roomuser = RoomUser.where.not(user_id: current_user.id).find_by(room_id: room.id)
        if roomuser
          @roomusers << roomuser
        end
      end
      @roomusers.each do |roomuser|
        user = User.find_by(id: roomuser.user_id)
        if user
          @users << user
        end
      end
      render("chats/create")
    end
  end

  def create_individual
    @user = User.find_by(id: params[:id])
    @room = Room.new(name: "#{@user.name}&#{current_user.name}", is_group_chat: false)
    unless @room.save
      render("users/show")
      exit
    end
    @members = [current_user, @user]
    @members.each do |member|
      @room_user = RoomUser.new(room_id: @room.id, user_id: member.id)
      unless @room_user.save
        render("users/show")
      end 
    end
    redirect_to("/chats/#{@room.id}")
  end

  def edit
  end
  
  def update
  end
  
  def delete
  end
end
