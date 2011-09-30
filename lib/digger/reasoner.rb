require 'net/http'
require 'nokogiri'

#--
# TODO: Handle error and warning messages:
# TODO: process <error> element!
# TODO: <ok> element can have embedded <warning> and other stuff!
# Probably, set/reset @errors and @warnings, when applicable?
#++

# DIG/1.1 interface
module Digger

  # The core!
  class Reasoner

    attr_reader :host, :port, :response
    attr_reader :knowledge_bases

    # Init an instance of a DIG query engine.
    def initialize(host = 'localhost', port = 8081)
      @host, @port = host, port
      @knowledge_bases = []
      xslt_file = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "data", "dig.xslt"))
      @xslt = Nokogiri::XSLT.parse(File.read(xslt_file))
    end

    # Specific DIG queries follow
    
    # Get reasoner identification/capabilities data.
    def info(options = {})
      capabilities = {}
      query(Query::GET_IDENTIFIER, options) do |xml|
        xml.root.attributes.each do |attr_name, attr_value|
          if %w(name message version).include?(attr_name)
            capabilities[attr_name.to_sym] = attr_value
          end
        end
        xml.xpath("/xmlns:identifier/xmlns:supports/xmlns:*").each do |supports|
          s_name = supports.name.to_sym
          capabilities[s_name] = []
          supports.children.select(&:element?).each do |feature|
            capabilities[s_name] << feature.name
          end
        end
      end
      capabilities
    end

    # Create a new knowledge base and return its UUID.
    # Returns nil on errors.
    def new_knowledge_base(options = {})
      query(Query::NEW_KB, options) do |xml|
        if (kb = xml.xpath("/xmlns:response/xmlns:kb").first)
          kb_uuid = kb.attributes['uri'].to_s
          @knowledge_bases << kb_uuid
          kb_uuid
        end
      end
    end

    # Release (close) a knowledge base, specified by URI.
    # Returns KB UUID on success, or nil on errors.
    def release_knowledge_base(kb_uuid, options = {})
      query(Query::RELEASE_KB % kb_uuid, options) do |xml|
        if xml.xpath("/xmlns:response/xmlns:ok").any?
          @knowledge_bases.delete(kb_uuid)
        end
      end
    end

    # Upload an ontology file into KB.
    # Returns 'true' on success or 'false' on failure.
    def upload(kb_uuid, data, options = {})
      ontology_doc = Nokogiri::XML.parse(data)
      dig_document = @xslt.transform(ontology_doc, ["kb_uuid", "'#{kb_uuid}'"]).to_s
      query(dig_document, options) do |xml|
        xml.xpath("/xmlns:response/xmlns:ok").any?
      end
    end

    # ASK query.
    # Options are:
    #   namespaces::    hash of "name" => "URI" pairs
    def ask(kb_uuid, body, options = {})
      nss = if options[:namespaces]
        Query::NSS + options[:namespaces].map{|ns_name, ns_uri| "xmlns:#{ns_name}='#{ns_uri}'" }.join("\n")
      else
        Query::NSS
      end
      body = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<asks #{nss} uri="#{kb_uuid}">#{body}</asks>
HERE
      output = {}
      query(body, options) do |xml|
        xml.root.children.select(&:element?).each do |response|
          # note that results with identical IDs are concatenated
          prepare_output(response).each do |result_id, result_value|
            if output.has_key?(result_id) && output[result_id].is_a?(Array) && result_value.is_a?(Array)
              output[result_id].concat(result_value)
            else
              # be careful not to specify same IDs for queries
              # that yield results of different types!
              output.merge!(result_id => result_value)
            end
          end
        end
      end
      output
    end

    def all_concept_names(kb_uuid, options = {})
      ask(kb_uuid, "<allConceptNames/>", options).values.flatten
    end

    def all_role_names(kb_uuid, options = {})
      ask(kb_uuid, "<allRoleNames/>", options).values.flatten
    end

    def all_individuals(kb_uuid, options = {})
      ask(kb_uuid, "<allIndividuals/>", options).values.flatten
    end

    def children(kb_uuid, klass, options = {})
      ask(kb_uuid, "<children><catom name='#{klass}'/></children>", options).values.flatten
    end

    def descendants(kb_uuid, klass, options = {})
      ask(kb_uuid, "<descendants><catom name='#{klass}'/></descendants>", options).values.flatten
    end

    def parents(kb_uuid, klass, options = {})
      ask(kb_uuid, "<parents><catom name='#{klass}'/></parents>", options).values.flatten
    end

    def ancestors(kb_uuid, klass, options = {})
      ask(kb_uuid, "<ancestors><catom name='#{klass}'/></ancestors>", options).values.flatten
    end


    private

    # Processing of common response cases.
    def prepare_output(response)
      output = {}
      response_id = (response.attributes['id'] && response.attributes['id'].value) || ''

      case response.name
      when "conceptSet", "roleSet", "individualSet", "individualPairSet"
        output[response_id] = []
        response.children.select(&:element?).each do |synonyms|
          synonyms.children.select(&:element?).each do |atom|
            next unless %w(catom ratom individual individualPair).include?(atom.name)
            output[response_id] << atom.attributes['name'].value
          end
        end
      when "true", "false"
        output[response_id] = (response.name == "true")
      when "error"
        error_code = (response.attributes['code'] && response.attributes['code'].value) || 'UNKNOWN'
        error_message = (response.attributes['message'] && response.attributes['message'].value) || '--'
        Digger.logger.error("[DIG] Error #{error_code}: #{error_message} (Query ID='#{response_id}')") if Digger.logger
      else
        Digger.logger.error("[DIG] Unexpected response received: #{response}") if Digger.logger
      end

      output
    end

    # Send a custom query to the DIG reasoner.
    # Yields output XML if response is successful.
    # Options are:
    #   :read_timeout   timeout to read from the socket
    def query(body, options = {})
      output = Net::HTTP.start(@host, @port) do |http|
        http.read_timeout = options[:read_timeout] if options[:read_timeout]
        http.post('/', body, HTTP_HEADER.merge('Content-Length' => body.length.to_s))
      end
      Digger.logger.debug("[DIG]: #{output.body}") if Digger.logger
      @response = output.response
      yield Nokogiri::XML.parse(output.body) if @response.code_type == Net::HTTPOK
    end

  end

end
