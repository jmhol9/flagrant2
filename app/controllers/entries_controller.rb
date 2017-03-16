class EntriesController < ApplicationController
    before_action :redirect_if_logged_out

    def create 
        tournament = Tournament.find(params[:entry][:tournament_id]);

        customer = Stripe::Customer.create(
            :email => params[:stripeEmail],
            :source  => params[:stripeToken]
        )

        charge = Stripe::Charge.create(
            :customer    => customer.id,
            :amount      => tournament.entry_fee,
            :description => 'Rails Stripe customer',
            :currency    => 'usd'
        )

        entry = Entry.create(
            tournament_id: tournament.id,
            user_id: current_user.id,
            points: tournament.allowance
        )

        redirect_to tournament_url(tournament.id)

    rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
    end

    def show
        entry = Entry.find(params[:id])
        @user = entry.user
        @picks = entry.picks
        if current_user != @user
            @picks.select { |pick| pick.round.picks_close < DateTime.now }
        end
    end

    private 
    def entry_params
        params.require(:entry).permit(:tournament_id)
    end
end
