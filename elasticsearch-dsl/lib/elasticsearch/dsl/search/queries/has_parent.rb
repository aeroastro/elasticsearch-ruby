# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Queries

        # A query which returns children documents for parent documents matching a query
        #
        # @example Return comments for articles about Ruby
        #
        #     search do
        #       query do
        #         has_parent do
        #           type 'article'
        #           query do
        #             match title: 'Ruby'
        #           end
        #         end
        #       end
        #     end
        #
        # @example
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-has-parent-query.html
        #
        class HasParent
          include BaseComponent

          option_method :parent_type
          option_method :score_mode
          option_method :inner_hits

          # DSL method for building the `query` part of the query definition
          #
          # @return [self]
          #
          def query(*args, &block)
            @query = block ? @query = Query.new(*args, &block) : args.first
            self
          end

          # Converts the query definition to a Hash
          #
          # @return [Hash]
          #
          def to_hash
            hash = super
            if @query
              _query = @query.respond_to?(:to_hash) ? @query.to_hash : @query
              hash[self.name].update(query: _query)
            end
            hash
          end
        end

      end
    end
  end
end
