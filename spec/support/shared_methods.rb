module SharedMethods
  
  #Default bad request
  def expect_bad_request
    expect(response).not_to be_success
    expect(response.code).to eq("422")
  end
  
  #Default good request
  def expect_good_request
    expect(response).to be_success
    expect(response.code).to eq("200")
  end
  
  #General method to analyze the results of the JSON results
  def expect_json(method = :eq, value_expected)
    results = JSON.parse(response.body)
    expect(results).to send(method, value_expected)
  end
  
  #Convert list of objects to array of jsons
  #The method convert_to_json SHOULD BE implemented in every test you want to run
  def get_list_json_format(objects)
    results = []
    objects.each do |object|
      results << convert_to_json(object)
    end
    return results
  end
end
