class Users::UrlController < ApplicationController
  include RackSessionsFix
  before_action :authenticate_user!, except: %i[top_visits redirect]

  def redirect
    url = Url.find_by(short_url: "#{request.base_url}/#{params[:short_url]}")

    if url && !url.deleted
      url.increment!(:visits)

      redirect_to url.original_url, allow_other_host: true
    else
      render plain: 'Url not found', status: :not_found
    end
  end

  def top_visits
    urls = Url.where(deleted: false).limit(10).order(visits: :desc)

    render json: {
      status: { code: 200 },
      data: UrlSerializer.new(urls).serializable_hash[:data].map { |url| url[:attributes] }
    }
  end

  def index
    urls = current_user.urls.where(deleted: false)
    render json: {
      status: { code: 200 },
      data: UrlSerializer.new(urls).serializable_hash[:data].map { |url| url[:attributes] }
    }
  end

  def show
    # TODO: recebe short_url e retorna a url original em json
  end

  def destroy
    # TODO: recebe o id e apaga o registro
  end

  def create
    unless valid_url?(url_params[:original_url])
      render json: {
        status: { message: 'Url is invalid.' }
      }, status: :unprocessable_entity
      return
    end

    short_code = SecureRandom.alphanumeric(6)
    shortned_url = "#{request.base_url}/#{short_code}"

    url = current_user.urls.build(url_params)
    url.short_url = shortned_url

    if url.save
      render json: {
        status: { code: 200, message: 'Url was created successfully.' },
        data: UrlSerializer.new(url).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: "Url couldn't be created successfully. #{url.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def valid_url?(url)
    url =~ /\A#{URI::regexp(['http', 'https'])}\z/
  end
end
