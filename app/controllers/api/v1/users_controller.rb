module Api
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])
        render json: { status: 200, message: 'ユーザ情報を取得しました', data: @user }
      end
    end
  end
end

