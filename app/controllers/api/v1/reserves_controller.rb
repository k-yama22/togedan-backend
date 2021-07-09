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
        @reserves = Reserve.where(user_id: params[:id])
        @events = []
        for id in @reserves do
          result = Event.find(id.event_id)
            @events.push(result)
        end
        render json: { status: 200, message: '予約情報の取得に成功しました。', data: @events }
      end

      def cancel
        @reserve = Reserve.find_by(user_id: reserve_params[:user_id], event_id: reserve_params[:event_id])
        @reserve.destroy
        render json: { status: 200, message: '予約キャンセルが完了しました。', data: @reserve }
      end

      def create
        @reserve = Reserve.new(reserve_params)
        @event = Event.find(@reserve.event_id)
        # 登録する予約情報が既に存在するかチェック用
        @blank_check_reserve = Reserve.find_by(event_id: @reserve.event_id, user_id: @reserve.user_id)
        if @event.user_id == @reserve.user_id
          render json: { status: 400, message: "自身で登録したイベントを予約することはできません", data: @reserve.errors }
        elsif @blank_check_reserve
          render json: { status: 400, message: "既に予約済みです", data: @reserve }
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