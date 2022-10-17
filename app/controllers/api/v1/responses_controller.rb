class Api::V1::ResponsesController < ApplicationController
    
    #GET /responses
    def index 
        @responses = Response.all
        render json: @responses
    end

    #POST /responses
    def create
        @response = Response.new()
        if @response.save
            render json: @response
        else
            render error: {error: 'Unable to create the response.'}, status: 400
        end
    end

    # grammar [
    #    {producer: String, products: String[]}
    #   ]
    def response_params
        params.require(:response).permit(:grammar,:word)
    end

end
