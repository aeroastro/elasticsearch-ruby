# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Indices
      module Actions

        # Return information about one or more indices
        #
        # @example Get information about all indices
        #
        #     client.indices.status
        #
        # @example Get information about a specific index
        #
        #     client.indices.status index: 'foo'
        #
        # @example Get information about shard recovery for a specific index
        #
        #     client.indices.status index: 'foo', recovery: true
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                 to perform the operation on all indices
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        # @option arguments [Boolean] :recovery Return information about shard recovery (progress, size, etc)
        # @option arguments [Boolean] :snapshot Return information about snapshots (when shared gateway is used)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-indices-status/
        #
        def status(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_status'

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:status, [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :recovery,
            :snapshot ].freeze)
      end
    end
  end
end
