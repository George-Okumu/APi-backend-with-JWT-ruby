class Api::V1::AuthController < ApplicationController
    skip_before_action :require_login, only: :create
    
    def create
        # byebug
        @user = User.find_by(username: login_params[:username])
        if  @user && @user.authenticate(login_params[:password])
            token = encode_token({user_id: @user.id})
            render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        else
            render json: { message: 'Invalid username or password' }, status: :unauthorized
        end
    end

    private 

    def login_params
        params.require(:user).permit(:username, :password_digest)
    end
end
