class SessionsController < ApplicationController
    # before_action :redirect_unless_logged_out, only: [:new, :create]
    # before_action :redirect_if_logged_out, only: [:destroy]

    def new

    end

    def create
        @user = User.find_by_credentials(
        params[:user][:email],
        params[:user][:password].strip
        )


        if @user
            login!(@user)
            tournament = Tournament.first
            redirect_to tournament_url(tournament)
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
