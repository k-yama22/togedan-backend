module Api
  module V1
    class ReservesController < ApplicationController
      before_action :set_reserve, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show]

      def index
        reserves = Reserve.order(created_at: :desc)
        render json: { status: 200, message: '予約情報の取得に成功しました。', data: reserves }
      end

      def show
        render json: { status: 200, message: '予約情報の取得に成功しました。', data: @reserve }
      end

      def events
        @reserves = Reserve.where(user_id: params[:id], reserve_sts: "1")
        @events_arr = []
        for id in @reserves do
          result = User.joins(:events).select("users.image, users.id, events.id AS event_id, events.event_name, events.genre, events.location, events.event_date, events.start_time, events.end_time, events.event_message, events.max_people").find_by(events: {id: id.event_id, event_sts: "1"})
          @events_arr.push(result)
          # if @events.length > 2
          #   break
          # end
        end
        if @events_arr.blank?
          @events = []
        else
          @events_arr = @events_arr.compact
          @events = @events_arr.select{|a| a[:event_date] >= Date.today}
        end
        render json: { status: 200, message: '予約情報の取得に成功しました。', data: @events }
      end

      def event
        event_id = reserve_params[:event_id]
        user_id = reserve_params[:user_id]
        @reserve = Reserve.find_by(event_id: event_id, user_id: user_id, reserve_sts: "1")
        if @reserve
          @event = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").find_by(events: {id: @reserve.event_id})
          render json: { status: 200, message: '詳細情報の取得に成功しました。', data: @event }
        else
          render json: { status: "ERROR", message: '詳細情報の取得に失敗しました。', data: @reserve.errors }
        end
      end

      def history
        @reserves = Reserve.where(user_id: params[:id], reserve_sts: "1")
        # @my_history = @my_events.where(events: {event_date: ..Date.today})
        @events = []
        for id in @reserves do
          result = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").find_by(events: {id: id.event_id, event_sts: "1"})
          @events.push(result)
        end
        if @events.blank?
          @reserved_history = []
        else
          @events = @events.compact
          @reserved_history = @events.select{|a| a[:event_date] < Date.today}
        end
        render json: { status: 200, message: '予約情報の取得に成功しました。', data: @reserved_history }
      end

      def cancel
        @reserve = Reserve.find_by(user_id: reserve_params[:user_id], event_id: reserve_params[:event_id], reserve_sts: "1")
        # @reserve.destroy
        @reserve.update(reserve_sts: "2")
        render json: { status: 200, message: '予約キャンセルが完了しました。', data: @reserve }
      end

      def create
        @reserve = Reserve.new(reserve_params)
        @event = Event.find(@reserve.event_id)
        now = Time.now
        # 登録する予約情報が既に存在するかチェック用
        @blank_check_reserve = Reserve.find_by(event_id: @reserve.event_id, user_id: @reserve.user_id, reserve_sts: "1")
        if @event.user_id == @reserve.user_id
          render json: { status: 400, message: "自身で登録したイベントを予約することはできません", data: @reserve.errors }
        elsif @blank_check_reserve
          render json: { status: 400, message: "既に予約済みです", data: @reserve }
        elsif (@event.event_date.strftime("%Y-%m-%d") + " " + @event.start_time.strftime("%H%M")) < now.strftime("%Y-%m-%d %H%M")
          render json: { status: 400, message: "過去に開催されたイベントのため予約できません", data: @reserve }
        elsif @reserve.save
          render json: { status: 200, message: "予約が完了しました。", data: @reserve }
        else
          render json: { status: 'ERROR', message: "予約に失敗しました。", data: @reserve.errors }
        end
      end

      def update
        if @reserve.update(reserve_params)
          render json: { status: 200, message: '予約情報の更新が完了しました。', data: @reserve }
        else
          render json: { status: 'ERROR', message: '予約情報の更新に失敗しました。', data: @reserve.errors }
        end
      end

      def destroy
        @reserve.destroy
        render json: { status: 200, message: '予約情報の削除が完了しました。', data: @reserve }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_reserve
        @reserve = Reserve.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def reserve_params
        params
          .require(:reserve)
          .permit(
            :event_id,
            :user_id,
            :reserve_sts
          )
      end
    end
  end
end