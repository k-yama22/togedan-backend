module Api
  module V1
    class EventsController < ApplicationController
      before_action :set_event, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show]

      def index
        events = Event.order(created_at: :desc)
        render json: { status: 200, message: 'Loaded events', data: events }
      end

      def show
        render json: { status: 200, message: 'Loaded the event', data: @event }
      end

      def own
        @my_events = Event.where(user_id: params[:id], event_sts: "1")
        render json: { status: 200, message: 'Loaded the my events', data: @my_events }
      end

      def history
        @my_events = Event.where(user_id: params[:id])
        @my_history = @my_events.where(event_date: Date.today..)
        render json: { status: 200, message: 'Loaded the my events', data: @my_history }
      end

      def cancel
        @event = Event.find_by(user_id: event_params[:user_id], id: event_params[:id])
        @event.destroy
        render json: { status: 200, message: 'Cancel the event', data: @event }
      end

      def create
        @event = Event.new(event_params)
        if @event.invalid?
          render json: { status: 422, data: @event.errors }
        elsif @event.save
          render json: { status: 200, message: "登録が完了しました。", data: @event }
        else
          render json: { status: "ERROR", data: @event.errors }
        end
      end

      def update
        if @event.update(event_params)
          render json: { status: 200, message: '更新が完了しました', data: @event }
        else
          render json: { status: 422, message: '更新に失敗しました', data: @event.errors }
        end
      end

      def destroy
        @event.destroy
        render json: { status: 200, message: 'Deleted the event', data: @event }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def event_params
        params
          .require(:event)
          .permit(
            :id,
            :user_id,
            :event_name,
            :genre,
            :location,
            :event_date,
            :start_time,
            :end_time,
            :event_message,
            :max_people,
            :event_sts,
          )
      end
    end
  end
end