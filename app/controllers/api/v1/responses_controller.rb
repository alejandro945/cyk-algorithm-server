require "#{Rails.root}/app/services/cyk_algorithm.rb"

class Api::V1::ResponsesController < ApplicationController
    before_action :parse_request, only: [:create]

    #GET /responses
    def index 
        @responses = Response.all
        render json: @responses
    end

    #POST /responses
    def create
        service = CykService.new(params[:grammar], params[:word])
        res = service.algorithm
        @response = Response.new(word: params[:word],isAdmitted: res)
        if @response.save
            render json: @response
        else
            render error: {error: 'Unable to create the response.'}, status: 400
        end
    end

    private

    def parse_request
        @json = JSON.parse(request.body.read)
    end

    # grammar [
    #    {producer: String, products: String[]}
    #   ]

end
