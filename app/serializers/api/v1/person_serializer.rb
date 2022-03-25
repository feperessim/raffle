# frozen_string_literal: true

module Api
  module V1
    class PersonSerializer < ActiveModel::Serializer
      attributes :name, :cpf, :birthday
    end
  end
end
