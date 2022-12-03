class Api::GetModelController < ApplicationController
  respond_to :json

  # GET /api/model_find
  def show_with_id
    # ### EXAMPLE:
    # {
    #   "model": ModelName,
    #   "id": object_id
    # }

    model_str = request["model"].split(' ')[0].capitalize()
    object_id = request["id"]
    begin
      object = eval("#{model_str}.find(#{object_id})")
      render status: 200, json: {
        success: true,
        response: "#{model_str} object retreived successfully.",
        object: object.to_json
      }
    rescue => e
      render status: 400, json: {
        success: false,
        response: "Failed: #{e}!"
      }
    end

  end

  # GET /api/model_where
  def show_where
    # ### EXAMPLE:
    # {
    #   "model": ModelName,
    #   "params": JSON_params_as_you_like
    # }

    model_str = request["model"].split(' ')[0].capitalize()
    params = JSON.parse(request["params"], symbolize_names: true)
    begin
      object = eval("#{model_str}.where(#{params})")
      render status: 200, json: {
        success: true,
        response: "#{model_str} object retreived successfully.",
        object: object.to_json
      }
    rescue => e
      render status: 400, json: {
        success: false,
        response: "Failed: #{e}!"
      }
    end
    
  end

  # POST /api/model_create
  def create
    # ### EXAMPLE:
    # {
    #   "model": ModelName,
    #   "params": JSON_params_as_you_like
    # }

    model_str = request["model"].split(' ')[0].capitalize()
    params = JSON.parse(request["params"], symbolize_names: true)
    begin
      object = eval("#{model_str}.create(#{params})")
      render status: 200, json: {
        success: true,
        response: "#{model_str} object created successfully."
      }
    rescue => e
      render status: 400, json: {
        success: false,
        response: "Failed: #{e}!"
      }
    end
    
  end

  # PATCH/PUT /api/model_update
  def update
    # ### EXAMPLE:
    # {
    #   "model": ModelName,
    #   "id": object_id,
    #   "params": JSON_params_as_you_like
    # }


    model_str = request["model"].split(' ')[0].capitalize()
    object_id = request["id"]
    params = JSON.parse(request["params"], symbolize_names: true)
    begin
      object = eval("#{model_str}.find(#{object_id})")
      object.update(params)
      render status: 200, json: {
        success: true,
        response: "#{model_str} object updated successfully."
      }
    rescue => e
      render status: 400, json: {
        success: false,
        response: "Failed: #{e}!"
      }
    end
    
  end
  
  # DELETE /api/model_destroy
  def destroy
    # ### EXAMPLE:
    # {
    #   "model": ModelName,
    #   "id": object_id
    # }

    model_str = request["model"].split(' ')[0].capitalize()
    object_id = request["id"]
    begin
      object = eval("#{model_str}.find(#{object_id})")
      object.delete
      render status: 200, json: {
        success: true,
        response: "#{model_str} object deleted successfully."
      }
    rescue => e
      render status: 400, json: {
        success: false,
        response: "Failed: #{e}!"
      }
    end
    
  end

end