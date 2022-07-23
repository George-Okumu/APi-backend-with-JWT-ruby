class Api::V1::UsersController < ApplicationController
    skip_before_action :require_login, only: :create # here we access the create method without authorizing user
    def create
        @user = User.create(user_params)

        if @user.valid?
            @token = encode_token(user_id: @user.id)
            render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
        else
            render json: { error: 'failed to create user' }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password_digest, :bio, :avatar)
    end
end
