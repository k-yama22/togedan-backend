module Api
  module V1
    class EventsController < ApplicationController
      before_action :set_event, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show search]

      def index
        events = Event.order(created_at: :desc)
        users = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people")
        render json: { status: 200, message: 'Loaded events', data: users }
      end

      def show
        @event = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").find_by(events: {id: params[:id]})
        render json: { status: 200, message: 'Loaded the event', data: @event }
      end

      def own
        @events = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").where(events: {user_id: params[:id], event_sts: "1"})
        @my_events = @events.where(events: {event_date: Date.today..})
        render json: { status: 200, message: 'Loaded the my events', data: @my_events }
      end

      def history
        @my_events = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").where(events: {user_id: params[:id]})
        @my_history = @my_events.where(events: {event_date: ...Date.today})
        render json: { status: 200, message: 'Loaded the my events', data: @my_history }
      end

      def detail
        @my_event = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").find_by(events: {id: event_params[:id], user_id: event_params[:user_id], event_sts: "1"})
        render json: { status: 200, message: 'Loaded the my events', data: @my_event }
      end

      def search
        genre = event_params[:genre]
        location = event_params[:location]
        event_date = event_params[:event_date]
        if event_date.nil?
          @events = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").where('genre LIKE(?) and location LIKE(?)', "%#{genre}%", "%#{location}%")
          # @events = Event.where('genre LIKE(?) and location LIKE(?)', "%#{genre}%", "%#{location}%")
        else
          @events = User.joins(:events).select("users.image,users.id, events.id AS event_id,events.event_name,events.genre,events.location,events.event_date,events.start_time,events.end_time,events.event_message,events.max_people").where('genre LIKE(?) and location LIKE(?) and event_date = (?)', "%#{genre}%", "%#{location}%", "%#{event_date}%")
          # @events = Event.where('genre LIKE(?) and location LIKE(?) and event_date = (?)', "%#{genre}%", "%#{location}%", "%#{event_date}%")
        end
        # @events = Event.where('genre LIKE(?) and location LIKE(?) and event_date = (?)', "%#{genre}%", "%#{location}%", "%#{event_date}%")
        render json: { status: 200, message: '検索が完了しました', data: @events }
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