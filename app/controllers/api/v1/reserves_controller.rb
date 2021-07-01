module Api
  module V1
    class ReservesController < ApplicationController
      before_action :set_reserve, only: %i[show update destroy]

      def index
        reserves = Reserve.order(created_at: :desc)
        render json: { status: 200, message: 'Loaded reserves', data: reserves }
      end

      def show
        render json: { status: 200, message: 'Loaded the reserve', data: @reserve }
      end

      def events
        @reserves = Reserve.where(user_id: params[:id])
        @events = []
        for id in @reserves do
          result = Event.find(id.event_id)
            @events.push(result)
        end
        render json: { status: 200, message: 'Loaded the reserved events', data: @events }
      end

      def cancel
        @reserve = Reserve.find_by(user_id: reserve_params[:user_id], event_id: reserve_params[:event_id])
        @reserve.destroy
        render json: { status: 200, message: 'Cancel the reserve', data: @reserve }
      end

      def create
        @reserve = Reserve.new(reserve_params)
        @event = Event.find(@reserve.event_id)
        if @event.user_id == @reserve.user_id
          render json: { status: 400, message: "自身で登録したイベントを予約することはできません", data: @reserve.errors }
        elsif @reserve.save
          render json: { status: 200, message: "Created SUCCESS", data: @reserve }
        else
          render json: { status: 'ERROR', data: @reserve.errors }
        end
      end

      def update
        if @reserve.update(reserve_params)
          render json: { status: 200, message: 'Updated the reserve', data: @reserve }
        else
          render json: { status: 'ERROR', message: 'Not updated', data: @reserve.errors }
        end
      end

      def destroy
        @reserve.destroy
        render json: { status: 200, message: 'Deleted the reserve', data: @reserve }
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