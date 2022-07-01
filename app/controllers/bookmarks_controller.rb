class BookmarksController < ApplicationController
  before_action :require_user!

  def index
    client = TwitterClient.new(current_user)

    _bookmarks = client.bookmarks

    @authors = {} # id of the author => author data
    _bookmarks[:includes][:users].each do |user|
      @authors[user[:id]] = user
    end

    @bookmarks = _bookmarks[:data]

    @folders = {} # domain.id:entity.id => "entity.name"
    @bookmarks.each do |mark|
      mark.fetch(:context_annotations, []).each do |ca|
        key = context_annotation_key(ca)
        @folders[key] = ca[:entity][:name]
      end
    end

    if params[:folder]
      @bookmarks = @bookmarks.select do |mark|
        mark.fetch(:context_annotations, []).any? do |ca|
          context_annotation_key(ca) == params[:folder]
        end
      end
    end
  end

  private

  def context_annotation_key(ca)
    "#{ca[:domain][:id]}.#{ca[:entity][:id]}"
  end
end
