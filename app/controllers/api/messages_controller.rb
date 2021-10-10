class Api::MessagesController < ApplicationController
  def show
    message = Message.find(params[:id])

    if message.deleted_at
      render json: { success: false, error: "You already requested this message" }, status: :unprocessable_entity
    else
      message.update(deleted_at: Time.now)
      render json: { success: true, message: message.body }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, error: e.message }, status: :not_found
  end

  def create
    message = Message.create!(message_params)
    render json: { success: true, link: message.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
