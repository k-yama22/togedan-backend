module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      def destroy
        if @resource
          @events = Event.where(user_id: @resource.id, event_sts: "1")

          # 開催イベントチェックフラグ
          @event_flg = false

          # 開催予定のイベントチェック
          if !@events.blank?
            today = Date.today;
            now = Time.now
            for event in @events do
              if (event.event_date.strftime("%Y-%m-%d") + " " + event.end_time.strftime("%H%M")) > now.strftime("%Y-%m-%d %H%M")
                @event_flg = true
              end
            end
          end

          if @event_flg
            render_destroy_event_error
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
        render_error(400, '開催予定のイベントがあるため削除できません', status: 'error')
      end

      def sign_up_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :user_sts, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :password, :password_confirmation, :current_password)
      end
    end
  end