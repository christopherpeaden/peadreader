require 'sinatra/base'

class FakeService < Sinatra::Base
  get '/:random' do
    last_modified "Tue, 01 Nov 2016 18:39:41 GMT"
    etag "5818e16d-84069"
    get_response 'sample_xml.rss'
  end


  private

    def get_response(filename)
      load_file(filename)
    end

    def load_file(filename)
      File.open(File.expand_path('./spec/support/sample_xml.rss'))
    end
end
