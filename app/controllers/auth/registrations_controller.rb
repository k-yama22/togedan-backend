module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      def destroy
        if @resource
          email = @resource.email
          t =  Time.current
          tf = t.strftime("%Y%m%d%H%M%S")
          random = SecureRandom.alphanumeric(20)
          random_email = tf + random + email
          @resource.update(user_sts: "2", email_check: email, email: random_email )
          yield @resource if block_given?
          render_destroy_success
        else
          render_destroy_error
        end
      end

      private
      def sign_up_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :user_sts, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :password, :password_confirmation, :current_password)
      end
    end
  end