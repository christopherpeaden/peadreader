class NewItemChecker 

  def self.check(parsed_feed, feed)
    failed_saves = 0
    successful_saves = 0
    parsed_feed.entries.each do |entry|
      build_and_save_item_from_entry_attributes(feed, entry) ? successful_saves +=1 : failed_saves +=1
      break if failed_saves == 4
      break if successful_saves == 30
    end
  end

  private

    def  self.build_and_save_item_from_entry_attributes(feed, entry)
      item = build(feed, entry)
      item.category_ids = feed.category_ids
      item.save
      #feed.items.create(item.attributes).id
    end

    def self.build(feed, entry)
      feed.items.build(
        title: entry.title,
        url: entry.url,
        image_thumbnail_url: build_image_thumbnail_url(entry),
        published_at: entry.published,
        feed_title: feed.title,
        user_id: feed.user.id 
      )
    end

    def self.build_image_thumbnail_url(entry)
      if entry.url =~ /youtube/ 
        "http://img.youtube.com/vi/#{entry.url.split('=')[1]}/hqdefault.jpg"
      elsif entry.url =~ /reddit/
        url_string = entry.content.match(/https:\/\/b.thumbs.redditmedia.com\/.*jpg/).to_s
        url_string.length > 0 ? url_string : nil
      else
        entry.image if entry.respond_to?(:image)
      end
    end
end
