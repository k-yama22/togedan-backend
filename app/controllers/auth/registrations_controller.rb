module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      private
      def sign_up_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :user_sts, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :user_name, :email, :email_check, :birthday, :phone, :image, :introduce, :password, :password_confirmation)
      end
    end
  end