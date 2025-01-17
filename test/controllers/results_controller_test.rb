require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  test "index action should display results when session has data" do
    session[:parsed_data] = [{ code: 'C100', value: 123.45, format: 'float', comments: [] }]
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
    assert_equal [{ code: 'C100', value: 123.45, format: 'float', comments: [] }], assigns(:results)
  end

  test "should redirect on create" do
    post :create, params: { file: fixture_file_upload('lab_input.txt', 'text/plain') }
    assert_redirected_to results_path
  end

  test "index action should handle empty session data" do
    get :index
    assert_response :success
    assert_nil assigns(:results)
  end

  test "create action should parse and redirect with valid file" do
    file = fixture_file_upload('lab_input.txt', 'text/plain')
    post :create, params: { file: file }
    assert_redirected_to results_path
    assert_not_nil session[:parsed_data]
  end
end
