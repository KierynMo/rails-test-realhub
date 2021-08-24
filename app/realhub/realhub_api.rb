class RealHubApi
  # Calls the orders api
  def order_api_call
    orders_response = RestClient.get("https://www.realhubapp.com/api/v2/orders.json?include_order_agency=true&include_order_status=true&include_order_campaign=true&include_order_items=true", header={ 'x-api-token': ENV['API_KEY'] })
    JSON.parse(orders_response.body)
  end

  # This takes the returned api data and formats it into a hash with all the orders and nested items
  def create_orders_hash(orders)
    # Calls get status options function to be used to create the order hash
    status_options = get_status_options

    orders_hash = {}
    orders.each do |order|
      #creates an array of item objects. This will fit into the order hash
      items_arr = []
      order['items'].each do |item|
        item_hash = {}
        item_hash[:id] = item['id']
        item_hash[:name] = item['title']
        item_hash[:quantity] = item['quantity']
        # There is an instance of 'no finish' on an item so built in error handling
        item['options'] == [] ? item_hash[:finish] = 'No finish' : item_hash[:finish] = item['options'][0]['value']['title']
        item_hash[:status] = status_options[item['status_id']]
        items_arr << item_hash
      end

      # This creates a hash for one order made up of many items. It fits into the orders hash
      order_hash = {
        agency_name: order['agency']['title'],
        address: campaign_address_format(order),
        items: items_arr
      }

      order_id = order['id']
      orders_hash[order_id] = order_hash
    end
    orders_hash
  end

  # Returns a hash of each status and their id
  def get_status_options
    status_response = RestClient.get("https://www.realhubapp.com/api/v2/statuses.json", header={ 'x-api-token': ENV['API_KEY'] })
    order_status_hash = JSON.parse(status_response.body)
    status_options = {}
    order_status_hash.each{ |status| status_options[status['id']] = status['title'] }
    status_options
  end

  # Takes in an order hash and formats the address
  def campaign_address_format(order)
    order_hash = order
    if order_hash['campaign'] == nil
      campaign_address = 'No address present'
    else
      campaign_address = "#{order['campaign']['address']}, #{order['campaign']['suburb_name']}"
    end
  end
end
