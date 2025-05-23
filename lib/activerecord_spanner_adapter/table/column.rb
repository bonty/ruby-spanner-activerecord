# Copyright 2020 Google LLC
#
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

module ActiveRecordSpannerAdapter
  class Table
    class Column
      attr_accessor :schema_name
      attr_accessor :table_name
      attr_accessor :name
      attr_accessor :type
      attr_accessor :limit
      attr_accessor :ordinal_position
      attr_accessor :allow_commit_timestamp
      attr_accessor :default
      attr_accessor :default_function
      attr_accessor :generated
      attr_accessor :primary_key
      attr_accessor :nullable
      attr_accessor :is_identity

      def initialize \
          table_name,
          name,
          type,
          schema_name: "",
          limit: nil,
          ordinal_position: nil,
          nullable: true,
          allow_commit_timestamp: nil,
          default: nil,
          default_function: nil,
          generated: nil,
          primary_key: false,
          is_identity: false
        @schema_name = schema_name.to_s
        @table_name = table_name.to_s
        @name = name.to_s
        @type = type
        @limit = limit
        @nullable = nullable != false
        @ordinal_position = ordinal_position
        @allow_commit_timestamp = allow_commit_timestamp
        @default = default
        @default_function = default_function
        @generated = generated == true
        @primary_key = primary_key
        @is_identity = is_identity
      end

      def spanner_type
        return "#{type}(#{limit || 'MAX'})" if limit_allowed?
        type
      end

      def options
        {
          limit: limit,
          null: nullable,
          allow_commit_timestamp: allow_commit_timestamp
        }.delete_if { |_, v| v.nil? }
      end

      private

      def limit_allowed?
        ["BYTES", "STRING"].include? type
      end
    end
  end
end
