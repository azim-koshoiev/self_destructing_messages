require "rails_helper"

RSpec.describe "Messages", type: :request do
  describe "GET /api/messages/:id/" do
    context "when the record exist" do
      before {
        Message.create(body: "Test Message")
        get api_message_url(Message.first.id)
      }

      it "returns response with correct mime type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a successful json string with success" do
        expect { JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(response_body.keys).to match_array(["success", "message"])

        expect(response_body).to match({
          "success" => be_truthy,
          "message" => be_instance_of(String),
        })

        expect(response_body["message"]).not_to be_empty
      end

      context "on second request" do
        before { get api_message_url(Message.first.id) }

        it "returns status code 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns a json string with error message" do
          expect { JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
          expect(response_body.keys).to match_array(["success", "error"])

          expect(response_body).to match({
            "success" => be_falsey,
            "error" => eq("You already requested this message"),
          })
        end
      end
    end
    context "when the record does not exist" do
      before {
        get api_message_url("testmessageid")
      }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found error" do
        expect(response_body).to match({
          "success" => be_falsey,
          "error" => match(/Couldn't find Message with 'id'=testmessageid/),
        })
      end
    end
  end

  describe "POST /api/messages/" do
    context "when the request is valid" do
      before {
        headers = { "ACCEPT" => "application/json" }
        post api_messages_url, :params => { :message => { :body => "My Message" } }, :headers => headers
      }

      it "returns response with correct mime type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns response with status 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns a successful json string with success message and link" do
        expect { response_body.with_indifferent_access }.not_to raise_exception
        expect(response_body.keys).to match_array(["success", "link"])

        expect(response_body).to match({
          "success" => be_truthy,
          "link" => be_instance_of(String),
        })

        expect(response_body["link"]).not_to be_empty
        expect(response_body["link"]).to include(ENV['app_host'])
      end

      it "returns valid link to message" do
        get response_body["link"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      before {
        headers = { "ACCEPT" => "application/json" }
        post api_messages_url,
             :params => { :message => { :body => "" } },
             :headers => headers
      }
      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a validation failure message" do
        expect(response_body).to match({
          "success" => be_falsey,
          "error" => match(/Validation failed: Body can't be blank/),
        })
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
