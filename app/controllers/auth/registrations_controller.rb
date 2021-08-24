module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      def destroy
        if @resource
          @events = Event.where(user_id: @resource.id, event_sts: "1")
          @reserves = Reserve.where(user_id: @resource.id, reserve_sts: "1")
          # 開催イベントチェックフラグ
          @event_flg = false
          @reserve_flg = false

          # 開催予定のイベントチェック
          if !@events.blank?
            now = Time.now
            for event in @events do
              if (event.event_date.strftime("%Y-%m-%d") + " " + event.end_time.strftime("%H%M")) > now.strftime("%Y-%m-%d %H%M")
                @event_flg = true
              end
            end
          end

          # 参加予定の予約情報チェック
          if !@reserves.blank?
            now = Time.now
            for reserve in @reserves do
              result = User.joins(:events).select("users.image, users.id, events.id AS event_id, events.event_name, events.genre, events.location, events.event_date, events.start_time, events.end_time, events.event_message, events.max_people").find_by(events: {id: reserve.event_id, event_sts: "1"})
              if (result.event_date.strftime("%Y-%m-%d") + " " + result.end_time.strftime("%H%M")) > now.strftime("%Y-%m-%d %H%M")
                @reserve_flg = true
              end
            end
          end

          if @event_flg
            render_destroy_event_error
          elsif @reserve_flg
            render_destroy_reserve_error
          else
            email = @resource.email
            time =  Time.current
            time_format = time.strftime("%Y%m%d%H%M%S")
            random = SecureRandom.alphanumeric(20)
            random_email = time_format + random + email
            @resource.update(user_sts: "2", email_check: email, email: random_email )
            yield @resource if block_given?
            render_destroy_success
          end
        else
          render_destroy_error
        end

      end

      private

      def render_destroy_event_error
        render_error(400, '開催予定のイベントがあるため退会できません', status: 'error')
      end

      def render_destroy_reserve_error
        render_error(400, '参加予定の予約情報があるため退会できません', status: 'error')
      end

      def sign_up_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :user_sts, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :password, :password_confirmation, :current_password)
      end
    end
  end