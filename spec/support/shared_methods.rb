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
  
  #general conversor of models or hashes (only accessible attributes) of a determinated model
  def convert_to_json(object, class_name)
    if object.is_a? ActiveRecord::Base
      ActiveSupport::JSON.decode(object.to_json)
    elsif object.is_a? Hash
      results = {}
      list_attrs_accessibles = class_name.singularize.classify.constantize.accessible_attributes.to_a.delete_if {|t| t.blank?}
      list_attrs_accessibles.each do |t| 
        results[t] = object[t.to_sym] if object[t.to_sym].present?
      end
      results
    end
  end
  
  #Convert list of objects (of a determinated model) to array of jsons
  def get_list_json_format(objects, model)
    results = []
    objects.each do |object|
      results << convert_to_json(object, model)
    end
    return results
  end
  
  #General method to validate one column of a Model
  def validate_column_errors(model, column, should_pass, i18n_index, params = {})
    method = (should_pass)? :not_to : :to
    expect((model.errors.get column).to_a).send method, include(I18n.t(i18n_index, params))
  end
end
