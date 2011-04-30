# -*- coding: utf-8 -*-
require 'pp'
require 'base64'
require 'rexml/document'
require 'appengine-apis/urlfetch'
require 'appengine-apis/memcache'
require 'hmac/sha2' ## from ruby-openid

module Kakaku
  class Item
    def self.search(category, keyword, page)
      Kakaku::Request.new('ItemSearch', {
                            :Keyword       => keyword,
                            :CategoryGroup => category || "ALL",
                            :PageNum       => page,
                          }).response
    end

    def self.info(product_id)
      Kakaku::Request.new('ItemInfo', {
                            :ProductID => product_id
                          }).response
    end

    def self.recommend_categories(keyword)
      []
    end
  end

  class Response
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def xml_doc
      unless @doc
        @doc = REXML::Document.new @body
      end
      @doc
    end

    def errors
      ary = []
      xml_doc.root.elements.each('//Error') {|err|
        ary.push err.elements['./Message'].text
      }
      ary
    end
  end

  ##
  ## Make URL for request, and Fetch
  ##
  class Request
    ## Keyword CategoryGroup SortOrder HitNum
    def initialize(operation, params)
      @operation = operation
      @params = params
    end

    def response
      Kakaku::Response.new(fetch)
    end

    def fetch
      url = make_url
      memcache = AppEngine::Memcache.new
      body = memcache.get(url)
      if body
        puts "Hit memcache: #{url}"
        return body
      end
      body = AppEngine::URLFetch.fetch(url).body
      memcache.set(url, body, 24 * 60 * 60)
      body
    end

    def make_url
      params_str = format_params(@params)
      "http://api.kakaku.com/WebAPI/#{@operation}/Ver1.0/#{@operation}.aspx?#{params_str}"
    end

    def format_params(params)
      #k = 

      keys = ['4ab030273fef5eba1742c6fad2589358',
              '5f6d2ea7763105a2e5e4977fa85a1fdb',
              '12b51b3615eaa26266c711f38445717e']
      params[:ApiKey] = keys[rand(keys.length)]
      params[:HitNum] = '20'
      params.map {|k, v|
        [ k.to_s, rfc3986_escape(v.to_s) ].join("=")
      }.sort.join("&")
    end

    def rfc3986_escape(str)
      safe_char = Regexp.new(/[A-Za-z0-9\-_.~]/)
      encoded = ""
      str.each_byte{|chr|
        if safe_char =~ chr.chr
          encoded = encoded + chr.chr
        else
          encoded = encoded + "%" + chr.chr.unpack("H*")[0].upcase
        end
      }
      return encoded
    end
  end

  class Category
    TABLE = {
      'ALL'    => 'All Category',
      'Pc'     => 'Computers',
      'Kaden'  => 'Electronics',
      'Camera' => 'Camera',
      'Game'   => 'Games',
#      'Gakki'  => '楽器',
      'Kuruma' => 'Automotive Parts',
      'Sports' => 'Sports',
#      'Brand'  => 'ブランド・腕時計',
      'Baby'   => 'Kids & Baby',
      'Pet'    => 'Pets',
      'Beauty_Health' => 'Health & Beauty'
    }

    def self.keys()
      TABLE.keys
    end

    def self.ja(key)
      TABLE[key] || nil
    end
  end
end



