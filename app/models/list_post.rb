class ListPost < ApplicationRecord
  belongs_to :post
  belongs_to :list
end
