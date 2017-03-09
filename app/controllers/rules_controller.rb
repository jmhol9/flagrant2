class RulesController < ApplicationController
    def index
        @tournament = Tournament.first
    end
end
