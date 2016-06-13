module FeedsHelper

  def fetch_feed_items(feed)
    parsed_feed = Feedjira::Feed.fetch_and_parse(feed.url)
    parsed_feed.entries.each do |entry|
      item = build_item(parsed_feed, entry)
      item.category_ids = feed.category_ids
      feed.items.create(item.attributes)
    end
  end

  def build_item(parsed_feed, entry)
    Item.new(
      title: entry.title,
      url: entry.url,
      image_thumbnail_url: ("http://img.youtube.com/vi/#{entry.url.split('=')[1]}/hqdefault.jpg" if entry.url =~ /youtube/),
      published_at: entry.published,
      feed_title: parsed_feed.title,
      user_id: current_user.id
    )
  end

  def save_outlines_from_opml(opml_doc, category_id)
    opml_doc.xpath("/opml/body/outline/outline").each do |outline|
      @feed = current_user.feeds.build(
        title: outline[:title],
        url: outline[:xmlUrl],
        category_ids: params["<option value="]
      )
      @feed.save
    end
  end
end
