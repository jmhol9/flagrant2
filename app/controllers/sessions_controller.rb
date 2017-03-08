class SessionsController < ApplicationController
    def new

    end

    def create
        @user = User.find_by_credentials(
        params[:user][:email],
        params[:user][:password].strip
        )

        if @user
            login!(@user)
            redirect_to tournaments_url
        else
            flash.now[:errors] = ["Invalid email / password combo."]
            render :new
        end
    end

    def destroy
        logout!
        redirect_to root_url
    end
end
