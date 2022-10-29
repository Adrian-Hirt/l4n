module Operations::Application
  class Sidebar < RailsOps::Operation
    schema3 {} # No params here

    def first_block
      'This is the first block of the sidebar'
    end
  end
end
