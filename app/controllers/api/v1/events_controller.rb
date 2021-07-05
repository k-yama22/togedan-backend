module Api
  module V1
    class EventsController < ApplicationController
      before_action :set_event, only: %i[show update destroy]

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
        now = Time.now
        today = Date.today;
        @check_event = Event.where(event_date: @event.event_date, start_time: @event.start_time.strftime('%H:%M')..@event.end_time.strftime('%H:%M'),end_time: @event.start_time.strftime('%H:%M')..@event.end_time.strftime('%H:%M'))
        if !@check_event.blank?
          render json: { status: 400, message: "既に登録済みのイベントと時間が重なっているため登録できません", data: @check_event }
        elsif today > @event.event_date
          render json: { status: 400, message: "過去日は登録できません", data: @event }
        elsif today == @event.event_date && now.strftime('%H:%M') > @event.start_time.strftime('%H:%M')
          render json: { status: 400, message: "過去の時刻は登録できません", data: @event }
        elsif @event.save
          render json: { status: 200, message: "Created SUCCESS", data: @event }
        else
          render json: { status: 'ERROR', data: @event.errors }
        end
      end

      def update
        if @event.update(event_params)
          render json: { status: 200, message: 'Updated the event', data: @event }
        else
          render json: { status: 'ERROR', message: 'Not updated', data: @event.errors }
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