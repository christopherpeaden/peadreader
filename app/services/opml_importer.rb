class OPMLImporter

  def self.save_outlines(user, opml_doc)
    opml_doc.xpath("/opml/body/outline/outline").each do |outline|
      feed = build_new_feed_from_opml(user, outline)
      feed.save
    end
  end

  private

    def self.build_new_feed_from_opml(user, outline)
      user.feeds.build(
        title: outline[:title],
        url: outline[:xmlUrl]
      )
    end
end
