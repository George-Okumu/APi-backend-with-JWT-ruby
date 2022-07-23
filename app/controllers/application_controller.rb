class ApplicationController < ActionController::API
    #preventing unauthorized users
    before_action :require_login 

    def encode_token(payload)
        # payload = { name: 'becky' }
        # secret_key = "love"
        JWT.encode(payload, "secret_key")
        # JWT String = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiYmVja3kifQ.6dR9YmknlJ1AyuAVAFTlIPhUBzg67I6D970D0ze2OvA"
    end

    # According to the JWT Documentation 
    # (Links to an external site.): Whenever the user wants to access a protected route or resource, 
    # the user agent (browser in our case) should send the JWT, 
    # typically in the Authorization header using the Bearer schema. 
    # The content of the header should look like the following: Authorization: Bearer <token>
    # Knowing this, we can set up our server to anticipate a 
    # JWT sent along in request headers, instead of passing the token 
    # directly to ApplicationController#decoded_token:

    def auth_header
        # { 'Authorization': 'Bearer <token>' }
        request.headers["Authorization"]
    end

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            # headers: { 'Authorization': 'Bearer <token>' }
            begin
                # secret key = "secret_key"
                JWT.decode(token, "secret_key", true, algorithm: "HS256")
            rescue JWT::DecodeError
                nil
            end
        end

        # The Begin/Rescue syntax (Links to an external site.) allows us to  # rescue out of an exception in Ruby. 
        # Let's see an example in a rails console.
        # In the event our server receives and attempts to decode an invalid token
    end

    # below I was passing the token directly
    # def decoded_token(token)
    #     # token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiYmVja3kifQ.6dR9YmknlJ1AyuAVAFTlIPhUBzg67I6D970D0ze2OvA"
    #     # secret key = "love"
    #     JWT.decode(token, "secret_key")[0]

    #     # decode = [{"name"=>"becky"}, {"alg"=>"HS256"}] 
    #     # [0] = {"name"=>"becky"}, the payload


    # end


    # obtaining the user whenever an authorization header is present:
    def current_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end


    def logged_in
        # use ruby truthy instance
        !!current_user
    end

    def require_login
        render json: { message: 'Please login' }, status: :unauthorized unless logged_in?
    end

end
