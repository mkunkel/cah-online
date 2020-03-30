RSpec.describe ApplicationController do
  describe "GET /health-check" do
    it "returns a 200" do
      get :health_check
      expect(response).to have_http_status(:ok)
    end
  end
end
