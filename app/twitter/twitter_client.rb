class TwitterClient
  BASE_URL = "https://api.twitter.com/2"

  def initialize(user)
    @user = user
  end

  def me
    get '/users/me'
  end

  def get_user(handle)
    get "/users/by/username/#{handle}"
  end

  def get_spaces_by_creator_ids(creator_ids)
    query = {
      user_ids: creator_ids.join(','),
      expansions: 'speaker_ids,creator_id,host_ids',
      'topic.fields': 'name,description',
      'user.fields': 'username,name,location',
      'space.fields':'host_ids,created_at,creator_id,id,lang,invited_user_ids,participant_count,speaker_ids,started_at,ended_at,subscriber_count,topic_ids,state,title,updated_at,scheduled_start,is_ticketed',
    }.to_query
    get "/spaces/by/creator_ids?#{query}"
  end

  def my_spaces
    query = {
      user_ids: @user.twitter_id,
      expansions: 'speaker_ids,creator_id,host_ids',
      'topic.fields': 'name,description',
      'user.fields': 'username,name,location',
      'space.fields':'host_ids,created_at,creator_id,id,lang,invited_user_ids,participant_count,speaker_ids,started_at,ended_at,subscriber_count,topic_ids,state,title,updated_at,scheduled_start,is_ticketed',
    }.to_query
    get "/spaces/by/creator_ids?#{query}"
  end

  def bookmarks
    query = {
      'tweet.fields': 'context_annotations,created_at',
      'expansions': 'author_id',
      'user.fields': 'profile_image_url',
    }.to_query
    get "/users/#{@user.twitter_id}/bookmarks?#{query}"
  end

  private

  def get(path)
    request(:get, path)
  end

  def request(method, path, body: {})
    params = {
      method: method,
      url: "#{BASE_URL}#{path}",
      headers: headers
    }
    if method == :put || method == :post
      params[:payload] = body.to_json
      params[:headers]["Content-Type"] = "application/json"
    end

    begin
      response = RestClient::Request.execute(params)
      JSON.parse(response.body, symbolize_names: true)
    rescue => e
      Rails.logger.error e
      JSON.parse(e.response.body, symbolize_names: true)
    end
  end

  def headers
    {
      "Authorization": "Bearer #{@user.token}",
      "User-Agent": "RailsBookmarksSearch",
    }
  end
end
