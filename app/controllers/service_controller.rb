require 'base64'

class ServiceController < ApplicationController
  def build_info_path
    render :text => decode_hash_to_path and return if params[:decode]
    render :text => encode_path_to_hash and return if params[:encode]
    render :text => generated_path
  end

  private
    def generated_path
      node = Node.find(params[:parent_id])
      additional  = params[:additional].split('/').select{|a| !a.empty?}.join('/')
      ActiveSupport::Inflector.transliterate("/#{node.path.map{|a| a.slug.underscore}.join('/')}/#{additional}/#{additional}.xhtml").downcase.gsub(/[[:space:]]/,'_')
    end

    def decode_hash_to_path
      result = ''
      result << Base64.urlsafe_decode64(padded(params[:path_hash].gsub(/r.+?_/,'')))
      return result
    end

    def encode_path_to_hash
      Base64.urlsafe_encode64(params[:path_to_hash]).strip.tr('=', '')
    end

    def padded(hash)
      hash + ('=' * signs_count(hash))
    end

    def signs_count(hash)
      (hash.length % 4).zero? ? 0 : 4 - hash.length % 4
    end

end
