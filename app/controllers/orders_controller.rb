require_relative '../realhub/realhub_api.rb'

class OrdersController < ApplicationController
  def index
    # creates a formatted hash to be rendered
    rha = RealHubApi.new
    @status_options = rha.get_status_options
    @orders_hash = rha.create_orders_hash(rha.order_api_call)
  end

  # When you click the download artwork button on the view this function will trigger downloading the artwork
  def order_artwork
    order_item_response = RestClient.get("https://www.realhubapp.com/api/v2/order_items/#{params[:id]}.json?include_order_item_artwork=true", header={ 'x-api-token': ENV['API_KEY'], "User-Agent": "KierynChallenge" })
    order_item_hash = JSON.parse(order_item_response.body)
    #if there is no artwork then the function will return nil
    order_item_hash['artwork'] == nil ? nil : redirect_to(order_item_hash['artwork']['links']['download_url'])
  end

  # # Updates the status_id on the api server and then updates our orders_hash.
  # # Not currently functional as I can't get the params from the server-side JS
  # def update_status

  #   #change the status on the api server
  #   status_response = RestClient.put("https://www.realhubapp.com/api/v2/order_items/#{params[:item_id]}.json", {:status => "#{params[:new_status]}"}, header={ 'x-api-token': ENV['API_KEY'], "User-Agent": "KierynChallenge" } )
  #   status_hash = JSON.parse(status_response.body)
  #   #TODO - future features
  #   #check response from Api is valid otherwise raise error
  #   #render the page with the updated status associated with that item
  # end
end
